
//conditionals (can change during gameplay)
x_velocity = 0
y_velocity = 0
grounded = true
facing = FACING_RIGHT
can_dash = true
player_state = STATE_NORMAL
post_dash_drag_enabled = false;
can_grapple = true;
can_control = true;
wall_jump_direction = true //also ENUM this
wall_slide = false
gravity_multiplier = 0;
movement_speed_multiplier = 0;
falling = false;
jump_repeat_cur = 0;
last_ground_x = 0
last_ground_y = 0
soft_grounded = true
soft_grounded_flag = false
current_attack    = "";
attack_frame      = 0;
attack_hb_spawned = [];  // tracks which hitbox indices have been spawned
hit_ids_received  = ds_list_create();

//hard data (does not change during gameplay)
dash_velocity = 45
Grapling_hook_velocity = 200
Player_grapling_velocity = 35
max_move_speed = 9
acceleration = 1.8
drag = .625
post_dash_drag = 7.5
max_fall_speed = 30
wall_jump_velocity = 17.5
wall_slide_speed = 3.75
hazard_interaction_range = 600
jump_repeat_max = 9





