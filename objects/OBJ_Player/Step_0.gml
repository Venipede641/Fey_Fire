/// @description handles player movement

//gather inputs
var space = keyboard_check_pressed(vk_space)
var spaceHold = keyboard_check(vk_space)
var left = keyboard_check(ord("A"))
var left_arrow = keyboard_check(vk_left)
var right = keyboard_check(ord("D"))
var right_arrow = keyboard_check(vk_right)
var down = keyboard_check(ord("S"))
var haz_act = keyboard_check(ord("E"))
var down_arrow = keyboard_check(vk_down)
var up_arrow = keyboard_check(vk_up)
var graple_start = keyboard_check_pressed(ord("Q"))
var graple_hold = keyboard_check(ord("Q"))
var graple_release = keyboard_check_released(ord("Q"))
var shift = keyboard_check_pressed(vk_shift)
var shoot = mouse_check_button(mb_left)
var attack = mouse_check_button(ord("A"))


//declare variables
var predicted_x
var predicted_y
var xcollison 
var ycollison
var nearHazard

//get all hazards near the player and store them in a list
var hazardList = ds_list_create();
var hazardNum = collision_circle_list(x, y, hazard_interaction_range, OBJ_Hazard_master, false, true, hazardList, true);
if (hazardNum > 0)
{
    nearHazard = hazardList[|0]
	nearHazard.within_interaction_range = true
	for (var i = 1; i < hazardNum; ++i;)
    {
        hazardList[| i].within_interaction_range = false
    }
}

//player state, tracks what the player is doing and how to move them
//0 = normal movement
//1 = dashing
//2 = grappling
//3 = wall hang


switch(player_state)
{
case 0:
	if(x_velocity > max_move_speed){ //if player is moving faster than they can walk I. E dashing or grapple, slow them down
		if(post_dash_drag_enabled){ //after dashing drag is higher to slow them down aftr the burst of speed
			x_velocity -= post_dash_drag
		}
		else{ //otherwise slow by normal
			x_velocity -= drag
		}
	}
	else if (x_velocity < -max_move_speed){
		if(post_dash_drag_enabled){ //after dashing drag is higher to slow them down aftr the burst of speed
			x_velocity += post_dash_drag
		}
		else{ //otherwise slow by normal
			x_velocity += drag
		}
	}
	if(left_arrow && can_control) //start moveing player left
	{
		x_velocity -= acceleration
		if (x_velocity < -max_move_speed){
			x_velocity = -max_move_speed
		}
		facing = 0 //facing left
	}

	if(right_arrow && can_control) //start moving player right
	{
		x_velocity += acceleration
		if (x_velocity > max_move_speed){
			x_velocity = max_move_speed
		}
		facing = 1 //facing right
	}

	if(!right_arrow&&!left_arrow) //stop player if no movement key is held
	{
		
		// [TO DO, CHANGE THIS TO A RAPID DECELERATION INSTEAD OF A FLAT STOP]
		if(grounded){
			x_velocity = 0
		}
	}
	
	//wall jumps, if the player is close to a wall, enter a wall slide state where a wall jump can be inputed
		if(CollisonChecker(-5,0) == true && !grounded && falling)	{
			wall_jump_direction = 1
			wall_slide = true
		}
		else if(CollisonChecker(5,0) == true && !grounded && falling){
			wall_jump_direction = -1
			wall_slide = true
		}
		else{
			wall_jump_direction = 0
			wall_slide = false
		}

	//jumping
	if(space && can_control){
		if(wall_slide){ //if currently sliding down a wall, wall jump off
			y_velocity = OBJ_Game_Controller_Player.wall_player_jump_power //assign the correct y momentum
			x_velocity = wall_jump_velocity * wall_jump_direction //assign x momentum in the correct direction
			can_control = false
			alarm[3] = .1 * game_get_speed(gamespeed_fps) //takes control away from player for a breif moment
			wall_slide = 0 //no longer wall sliding now
			wall_jump_direction = 0
			can_dash = true //refresh dash
		}
		else if (grounded || soft_grounded){
			if(down_arrow ){ // passthrough oneway platforms if above one
				if(place_meeting(x,y+1,OBJ_One_Way_Platform)){
					y += 1
				}
			}
			else if (soft_grounded)	{
				jump_repeat_cur = jump_repeat_max
			}
		}
	}
	
	if (!spaceHold) //if not holding space, stop adding speed upwards
	{
		jump_repeat_cur = 0
	}
	//if( jump_repeat_cur > jump_repeat_max -2)
	//{
	//	jump_repeat_cur--
	//}
	else if (jump_repeat_cur > 0)
	{
		jump_repeat_cur--
		y_velocity =  OBJ_Game_Controller_Player.player_jump_power_rep
	}
	
	//dashing
	if(shift&&can_dash && can_control){
		player_state = 1 //enters dash movement
		can_dash = false // locks player out of dashing until they hit the ground again
		post_dash_drag_enabled = true
		alarm[0] = .1 * game_get_speed(gamespeed_fps) //alarm to set dashing to false
		alarm[1] = .25 * game_get_speed(gamespeed_fps)
	}
	
	//launch a grapple hook
	if(graple_start && can_grapple && can_control){
		can_grapple = false
		
		var arrow = instance_create_layer(OBJ_Player.x,OBJ_Player.y,"instances",OBJ_Grappling_Hook_Arrow)
		instance_create_layer(OBJ_Player.x,OBJ_Player.y,"instances",OBJ_Grapling_Rope)

		//select angle for grappling hook
		var angle = 0
		if(left_arrow && down_arrow){
			angle = 45
		}
		else if(right_arrow && down_arrow){
			angle = 135
		}
		else if(right_arrow && up_arrow){
			angle = 225
		}
		else if(left_arrow && up_arrow){
			angle = 315
		}
		else if(left_arrow){
			angle = 0
		}
		else if(down_arrow){
			angle = 90
		}
		else if(right_arrow){
			angle = 180
		}
		else if(up_arrow){
			angle = 270
		}
		var radiens = (angle - 90) * (pi/180)
		var x_multiplier = sin(radiens)
		var y_multiplier = cos(radiens)
		
		arrow.direction = angle
		arrow.image_angle = arrow.direction -270
		arrow.x_velocity = Grapling_hook_velocity * x_multiplier
		arrow.y_velocity = Grapling_hook_velocity * y_multiplier
		
	}
	
	//check to see if player is pulled by grapple hook
	if(graple_hold && can_control){
		var arrow = instance_nearest(x,y,OBJ_Grappling_Hook_Arrow)	
		if(arrow != noone){
			if(!arrow.in_flight && !arrow.returning){
				player_state = 2 //set movement state to grappling	
			}
		}
	}
	
	//tells the arrow to return to the player
	if(graple_release && can_control){
		var arrow = instance_nearest(x,y,OBJ_Grappling_Hook_Arrow)
		if(arrow != noone){
		arrow.returning = true
		}
	}
		
	//calculate gravity
	if(wall_slide){
		if(y_velocity > wall_slide_speed){
			y_velocity = wall_slide_speed
		}
		else if(y_velocity < 0){
			y_velocity = 0	
		}
		else{
			y_velocity += OBJ_Game_Controller_Player.gravity
		}
	}
	else if(y_velocity < max_fall_speed){
		if(!grounded && falling){
			y_velocity += OBJ_Game_Controller_Player.gravity *1.5
		}
		else if(!grounded)
		{
			y_velocity += OBJ_Game_Controller_Player.gravity
		}
		
		if(y_velocity > max_fall_speed){
			y_velocity = max_fall_speed	
		}	
	}
		
	var _move_count = abs(x_velocity);
	var _move_once = sign(x_velocity);


// This runs a loop, which runs 'move_count' times. All code in this block is repeated that many amount of times.
repeat (_move_count){
	var _collision_found = CollisonChecker(_move_once, 0);

	// This checks if collision_found is false, meaning a collision was not found, and the player is free to move once on the X axis.
	if (!_collision_found){
		x += _move_once;
	}
	// This 'else' block runs if a collision was found.
	else{
		x_velocity = 0;
		break;
	}
}

// We now repeat all of the previous steps to check for collisions on the Y axis.
var _move_count = abs(y_velocity);
var _move_once = sign(y_velocity);

// This runs a loop, which runs 'move_count' times. All actions attached to this are repeated that many amount of times.
repeat (_move_count){
	var _collision_found = CollisonChecker(0, _move_once);

	// This checks if collision_found is false, meaning a collision was not found, and the player is free to move once on the Y axis.
	if (!_collision_found){
		// In that case, move_once is added to the Y coordinate of the character.
		y += _move_once;
	}
	// This 'else' block runs if a collision was found.
	else{
		// In that case, we reset the Y velocity to 0, so the character stops its movement on that axis.
		y_velocity = 0;
		// Then we break out of the Repeat loop, as no more collision checks are required.
		break;
	}
}
	
	y = round(y)
	x = round(x)
	
	break;
	
	case 1: //dashing
	
	y_velocity = 0
	
	if(facing == 1) //if facing right
	{
		x_velocity = dash_velocity
	}
	else //facing left
	{
		x_velocity = -dash_velocity
	}
	
	var _move_count = abs(x_velocity);
	var _move_once = sign(x_velocity);


// This runs a loop, which runs 'move_count' times. All code in this block is repeated that many amount of times.
repeat (_move_count)
{
	// This calls the check_collision function to check for collisions on the X axis, if moved by the move_once value on that dimension.
	// The Y argument is set to 0, so for this collision there is no Y movement.
	// The result of the function, either true or false, is stored in the 'collision_found' variable, which is temporary.
	var _collision_found = CollisonChecker(_move_once, 0);

	// This checks if collision_found is false, meaning a collision was not found, and the player is free to move once on the X axis.
	if (!_collision_found)
	{
		// In that case, move_once is added to the X coordinate of the character.
		x += _move_once;
	}
	// This 'else' block runs if a collision was found.
	else
	{
		// In that case, we reset the X velocity to 0, so the character stops its movement on that axis.
		x_velocity = 0;
	
		// Then we break out of the Repeat loop, as no more collision checks are required.
		break;
	}
}

	y = round(y)
	x = round(x)
	break;

	case 2: //grappling
	
	var arrow = instance_nearest(x,y,OBJ_Grappling_Hook_Arrow)
	if(!graple_hold){ //if the player lets go of the key
		player_state =0	//return to normal movement
		arrow.returning = true	
	}
	else{		
		var gy = arrow.y
		var gx = arrow.x

		var relative_x = gx-x
		var relative_y = gy-y

		var trajectory = point_direction(gx,gy,x,y)
		var radiens = (trajectory - 90) * (pi/180)

		var x_multiplier = sin(radiens)
		var y_multiplier = cos(radiens)
		
		x_velocity = Player_grapling_velocity * x_multiplier
		y_velocity = Player_grapling_velocity * y_multiplier

	var _move_count = abs(x_velocity);
	var _move_once = sign(x_velocity);


// This runs a loop, which runs 'move_count' times. All code in this block is repeated that many amount of times.
repeat (_move_count){
	// This calls the check_collision function to check for collisions on the X axis, if moved by the move_once value on that dimension.
	// The Y argument is set to 0, so for this collision there is no Y movement.
	// The result of the function, either true or false, is stored in the 'collision_found' variable, which is temporary.
	var _collision_found = CollisonCheckerNoPlat(_move_once, 0);
	
	if(player_state != 3){
		if(x < arrow.x+5 && x > arrow.x-5 && player_state != 3){
		
			instance_destroy(arrow)
			//x_velocity = 0
			//y_velocity = 0
			player_state = 3
			break
		}
	}
	// This checks if collision_found is false, meaning a collision was not found, and the player is free to move once on the X axis.
	if (!_collision_found){
		// In that case, move_once is added to the X coordinate of the character.
		x += _move_once;
	}
	// This 'else' block runs if a collision was found.
	else{
		// In that case, we reset the X velocity to 0, so the character stops its movement on that axis.
		x_velocity = 0;
	
		// Then we break out of the Repeat loop, as no more collision checks are required.
		break;
	}
}

// We now repeat all of the previous steps to check for collisions on the Y axis.
// Everything is the same, but vel_x is replaced by vel_y, and the check_collision function takes a Y value (its second argument).
var _move_count = abs(y_velocity);
var _move_once = sign(y_velocity);

// This runs a loop, which runs 'move_count' times. All actions attached to this are repeated that many amount of times.
repeat (_move_count){
	// This calls the check_collision function to check for collisions on the Y axis, if moved by the move_once value.
	// The result of the function, either true or false, is stored in the 'collision_found' variable, which is temporary.
	var _collision_found = CollisonCheckerNoPlat(0, _move_once);

	// This checks if collision_found is false, meaning a collision was not found, and the player is free to move once on the Y axis.
	if(player_state != 3){
		if(y < arrow.y+5 && y > arrow.y-5)	{
			instance_destroy(arrow)
			//x_velocity = 0
			//y_velocity = 0
			player_state = 3
			break
		}
	}
	if (!_collision_found){
		// In that case, move_once is added to the Y coordinate of the character.
		y += _move_once;
	}
	// This 'else' block runs if a collision was found.
	else{
		// In that case, we reset the Y velocity to 0, so the character stops its movement on that axis.
		y_velocity = 0;
	
		// Then we break out of the Repeat loop, as no more collision checks are required.
		break;
	}
}
		
	}
	//round numbers to prevent issues
	y = round(y)
	x = round(x)
	break
	
	case 3:// wall hold, for holding place during grapple
	x_velocity = 0
	y_velocity = 0
	if(!graple_hold){ //if the player lets go of the key
		player_state =0	//return to normal movement
		can_grapple = true
	}
	if(shoot && can_shoot){
		
		can_shoot = false
		alarm[2] = .25 * game_get_speed(gamespeed_fps)
		
		var gy = mouse_y
		var gx = mouse_x

		var bullet = instance_create_layer(OBJ_Player.x,OBJ_Player.y,"instances",OBJ_Bullet)

		var relative_x = gx-x
		var relative_y = gy-y

		var trajectory = point_direction(gx,gy,x,y)
		var radiens = (trajectory - 90) * (pi/180)

		var x_multiplier = sin(radiens)
		var y_multiplier = cos(radiens)

		bullet.direction = trajectory
		bullet.image_angle = bullet.direction -180
		bullet.x_velocity = bullet_velocity * x_multiplier
		bullet.y_velocity = bullet_velocity * y_multiplier	
	}
	//round numbers to prevent issues
	y = round(y)
	x = round(x)
	break
}

ds_list_destroy(hazardList); //delete list to prevent memory leaks