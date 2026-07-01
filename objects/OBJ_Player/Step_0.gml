/// @description OBJ_Player — Step Event
/// Handles all player movement and state transitions.
///
/// Requires: scr_constants, scr_frames, scr_move_axis
///
/// player_state values → see scr_constants:
///   STATE_NORMAL (0), STATE_DASH (1), STATE_DIVE (2), STATE_ATTACK(3)

// ── Input ─────────────────────────────────────────────────────────────────────
var space      = keyboard_check_pressed(vk_space);
var spaceHold  = keyboard_check(vk_space);
var left_arrow = keyboard_check(vk_left);
var right_arrow= keyboard_check(vk_right);
var down_arrow = keyboard_check(vk_down);
var up_arrow   = keyboard_check(vk_up);
var haz_act    = keyboard_check(ord("E"));
var shift      = keyboard_check_pressed(vk_shift);
var dive       = keyboard_check_pressed(vk_control);

// ── Hazard Detection ──────────────────────────────────────────────────────────
// Collect all hazards within interaction range.
// The nearest one is marked active; the rest are marked out of range.
var hazardList = ds_list_create();
var hazardNum  = collision_circle_list(x, y, hazard_interaction_range,
                     OBJ_Hazard_master, false, true, hazardList, true);
if (hazardNum > 0) {
    nearHazard = hazardList[| 0];
    nearHazard.within_interaction_range = true;
    for (var i = 1; i < hazardNum; ++i) {
        hazardList[| i].within_interaction_range = false;
    }
}

// ── State Machine ─────────────────────────────────────────────────────────────
switch (player_state)
{

// ─────────────────────────────────────────────────────────────────────────────
case STATE_NORMAL:
// ─────────────────────────────────────────────────────────────────────────────

    // If moving faster than walk speed (post-dash), bleed off extra speed
    // using the appropriate drag value.
    if (x_velocity > max_move_speed) {
        x_velocity -= post_dash_drag_enabled ? post_dash_drag : drag;
    } else if (x_velocity < -max_move_speed) {
        x_velocity += post_dash_drag_enabled ? post_dash_drag : drag;
    }

    // Directional input — accelerate, clamp to walk speed, update facing.
    if (left_arrow && can_control) {
        x_velocity = max(x_velocity - acceleration, -max_move_speed);
        self.facing     = FACING_LEFT;
    }
    if (right_arrow && can_control) {
        x_velocity = min(x_velocity + acceleration, max_move_speed);
        self.facing     = FACING_RIGHT;
    }

    // No horizontal input — apply ground friction toward zero.
    if (!right_arrow && !left_arrow) {
        if (self.facing == FACING_RIGHT) {
            x_velocity = max(x_velocity - GROUND_DECEL, 0);
        } else {
            x_velocity = min(x_velocity + GROUND_DECEL, 0);
        }
    }

    // Wall-slide detection — probe WALL_CHECK_DIST pixels to each side.
    if (CollisonChecker(-WALL_CHECK_DIST, 0) && !grounded && falling) {
        wall_jump_direction =  1;
        wall_slide          = true;
    } else if (CollisonChecker(WALL_CHECK_DIST, 0) && !grounded && falling) {
        wall_jump_direction = -1;
        wall_slide          = true;
    } else {
        wall_jump_direction = 0;
        wall_slide          = false;
    }

    // Jump — wall jump, ground jump, or platform drop-through.
    if (space && can_control) {
        if (wall_slide) {
            // Wall jump: launch upward and sideways, briefly remove control.
            y_velocity          = OBJ_Game_Controller_Player.wall_player_jump_power;
            x_velocity          = wall_jump_velocity * wall_jump_direction;
            can_control         = false;
            alarm[3]            = scr_frames(0.1);
            wall_slide          = false;
            wall_jump_direction = 0;
            can_dash            = true;
        } else if (grounded || soft_grounded) {
            if (down_arrow && place_meeting(x, y + 1, OBJ_One_Way_Platform)) {
                y += 1; // drop through one-way platform
            } else if (soft_grounded) {
                jump_repeat_cur = jump_repeat_max;
            }
        }
    }

    // Jump hold — keep adding upward velocity while space is held and budget remains.
    if (!spaceHold) {
        jump_repeat_cur = 0;
    } else if (jump_repeat_cur > 0) {
        jump_repeat_cur--;
        y_velocity = OBJ_Game_Controller_Player.player_jump_power_rep;
    }

    // Dash — enter dash state for a short burst.
    if (shift && can_dash && can_control) {
        player_state           = STATE_DASH;
        can_dash               = false;
        post_dash_drag_enabled = true;
        alarm[0]               = scr_frames(0.1);  // ends dash velocity
        alarm[1]               = scr_frames(0.25); // clears post_dash_drag_enabled
    }

    // Dive — launch horizontally in facing direction.
    if (dive && can_control) {
        player_state = STATE_DIVE;
        dive_speed   = (self.facing == FACING_RIGHT) ? DIVE_SPEED_MAX : -DIVE_SPEED_MAX;
        y_velocity   = DIVE_LAUNCH_Y;
    }

    // Gravity.
    if (wall_slide) {
        // While wall-sliding: cancel upward movement, cap fall speed, add gravity normally.
        if      (y_velocity > wall_slide_speed) y_velocity = wall_slide_speed;
        else if (y_velocity < 0)                y_velocity = 0;
        else                                    y_velocity += OBJ_Game_Controller_Player.gravity;
    } else if (y_velocity < max_fall_speed) {
        var _grav_mult = (!grounded && falling) ? FALL_GRAVITY_MULT : 1;
        y_velocity     = min(y_velocity + OBJ_Game_Controller_Player.gravity * _grav_mult,
                             max_fall_speed);
    }

    // Move — step one pixel at a time to keep collision reliable.
    x_velocity = scr_move_axis(x_velocity, false, true);
    y_velocity = scr_move_axis(y_velocity, true,  true);

    x = round(x);
    y = round(y);
    break;


// ─────────────────────────────────────────────────────────────────────────────
case STATE_DASH:
// ─────────────────────────────────────────────────────────────────────────────

    // Dash cancels vertical momentum and moves at a fixed speed.
    y_velocity = 0;
    x_velocity = (self.facing == FACING_RIGHT) ? dash_velocity : -dash_velocity;

    x_velocity = scr_move_axis(x_velocity, false, true);

    x = round(x);
    y = round(y);
    break;


// ─────────────────────────────────────────────────────────────────────────────
case STATE_DIVE:
// ─────────────────────────────────────────────────────────────────────────────

    // Decelerate the dive — directional input adjusts the rate.
    if (dive_speed > DIVE_SPEED_MIN && self.facing == FACING_RIGHT) {
        if      (right_arrow) dive_speed -= dive_deceleration * DIVE_DECEL_WITH;
        else if (left_arrow)  dive_speed -= dive_deceleration * DIVE_DECEL_AGAINST;
        else                  dive_speed -= dive_deceleration;
    } else if (dive_speed < -DIVE_SPEED_MIN && self.facing == FACING_LEFT) {
        if      (right_arrow) dive_speed += dive_deceleration * DIVE_DECEL_WITH;
        else if (left_arrow)  dive_speed += dive_deceleration * DIVE_DECEL_AGAINST;
        else                  dive_speed += dive_deceleration;
    }

    // Clamp — dive never slows below the minimum speed.
    if      (dive_speed < DIVE_SPEED_MIN  && self.facing == FACING_RIGHT) dive_speed =  DIVE_SPEED_MIN;
    else if (dive_speed > -DIVE_SPEED_MIN && self.facing == FACING_LEFT)  dive_speed = -DIVE_SPEED_MIN;

    x_velocity = dive_speed;

    // Gravity.
    y_velocity = min(y_velocity + OBJ_Game_Controller_Player.gravity, max_fall_speed);

    // Move.
    x_velocity = scr_move_axis(x_velocity, false, true);
    y_velocity = scr_move_axis(y_velocity, true,  true);

    // Dive cancel — jump out of the dive.
    if (space) {
        player_state    = STATE_NORMAL;
        jump_repeat_cur = jump_repeat_max;
        y_velocity      = OBJ_Game_Controller_Player.player_jump_power_rep;
    }
    break;


// ─────────────────────────────────────────────────────────────────────────────
case  STATE_ATTACK:
// ─────────────────────────────────────────────────────────────────────────────
 attack_frame++;

    var atk      = global.attack_data[$ current_attack];
    var hb_defs  = atk[$ "hitboxes"];
    var hb_count = array_length(hb_defs);

    // Spawn hitboxes when their active window opens
    for (var i = 0; i < hb_count; i++) {
        var def = hb_defs[i];

        if (attack_frame >= def[$ "frame_start"]
        &&  attack_frame <= def[$ "frame_end"]
        && !attack_hb_spawned[i]) {

            // Flip X offsets based on facing direction
            var facing  = image_xscale >= 0 ? 1 : -1;
            var flipped = scr_flip_hitbox_def(def, facing);

            var hb = new Hitbox(self, flipped);
            obj_hitbox_manager.register_hitbox(hb);
            attack_hb_spawned[i] = true;
        }
    }

    // Attack finished
    if (attack_frame >= atk[$ "total_frames"]) {
        state          = STATE.IDLE;
        current_attack = "";
    }
	break;

} // end switch

// ── Cleanup ───────────────────────────────────────────────────────────────────
ds_list_destroy(hazardList); // always destroy to prevent memory leak
