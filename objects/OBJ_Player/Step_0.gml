/// @description handles player movement

var space = keyboard_check_pressed(vk_space)
var left = keyboard_check(ord("A"))
var right = keyboard_check(ord("D"))
var graple_start = keyboard_check_pressed(ord("Q"))
var graple_hold = keyboard_check(ord("Q"))
var graple_release = keyboard_check_released(ord("Q"))
var shift = keyboard_check_pressed(vk_shift)
var shoot = mouse_check_button(mb_left)

var predicted_x
var predicted_y
var xcollison 
var ycollison

if(y_velocity > 0) //if player is falling they are (probably) not grounded
{
	grounded = false	
}

var hazardList = ds_list_create();
var hazardNum = collision_circle_list(x, y, hazard_interaction_range, hazard_master, false, true, hazardList, true);
if (hazardNum > 0)
{
    var nearHazard = hazardList[|0]
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
	if(x_velocity > max_move_speed) //if player is oving faster than they can walk I. E dashing or grapple, slow them down
	{
		if(post_dash_drag_enabled)
		{
			x_velocity -= post_dash_drag
		}
		else
		{	
			x_velocity -= drag
		}
		if(x_velocity < max_move_speed)
		{
			x_velocity = max_move_speed	
		}
	}
	else if (x_velocity < -max_move_speed)
	{
		if(post_dash_drag_enabled)
		{
			x_velocity += post_dash_drag
		}
		else
		{	
			x_velocity += drag
		}
		if(x_velocity > max_move_speed)
		{
			x_velocity = -max_move_speed	
		}
	}
	if(left && can_control)
	{
		if(instance_place(x-5,y,OBJ_Floor_Master) != noone && !grounded)
		{
			wall_jump_direction = 1
			wall_slide = 1
		}
		else{
			wall_jump_direction = 0
			wall_slide = 0
		}
		if (x_velocity > -max_move_speed)
		{
			x_velocity -= acceleration
		}
		facing = 0 //facing left
	}

	if(right && can_control)
	{
		if(instance_place(x+5,y,OBJ_Floor_Master) != noone && !grounded)
		{
			wall_jump_direction = -1
			wall_slide = 1
		}
		else{
			wall_jump_direction = 0
			wall_slide = 0
		}
		if (x_velocity < max_move_speed)
		{
			x_velocity += acceleration
		}
		facing = 1 //facing right
	}

	if(!right&&!left)
	{
		if(grounded)
		{
			x_velocity = 0
		}
	}

	if(space && can_control)
	{
		if(wall_slide)
		{
			y_velocity += OBJ_Game_Controller_Player.player_jump_power
			x_velocity = wall_jump_velocity * wall_jump_direction
			can_control = false
			alarm[3] = .1 * game_get_speed(gamespeed_fps)
			wall_slide = 0
			wall_jump_direction = 0
			can_dash = true
		}
		else if (grounded){
		y_velocity += OBJ_Game_Controller_Player.player_jump_power
		grounded = false
		}
	}
	
	if(shift&&can_dash && can_control)
	{
		player_state = 1 //enters dash movement
		can_dash = false // locks player out of dashing until they hit the ground again
		post_dash_drag_enabled = true
		alarm[0] = .1 * game_get_speed(gamespeed_fps) //alarm to set dashing to false
		alarm[1] = .25 * game_get_speed(gamespeed_fps)
	}
	
	if(graple_start && can_grapple && can_control)
		{
		can_grapple = false
			
		var gy = mouse_y
		var gx = mouse_x

		var arrow = instance_create_layer(OBJ_Player.x,OBJ_Player.y,"instances",OBJ_Grappling_Hook_Arrow)
		instance_create_layer(OBJ_Player.x,OBJ_Player.y,"instances",OBJ_Grapling_Rope)

		var relative_x = gx-x
		var relative_y = gy-y

		var trajectory = point_direction(gx,gy,x,y)
		var radiens = (trajectory - 90) * (pi/180)

		var x_multiplier = sin(radiens)
		var y_multiplier = cos(radiens)

		arrow.direction = trajectory
		arrow.image_angle = arrow.direction -270
		arrow.x_velocity = Grapling_hook_velocity * x_multiplier
		arrow.y_velocity = Grapling_hook_velocity * y_multiplier
		}
	
	if(graple_hold && can_control)
	{
		var arrow = instance_nearest(x,y,OBJ_Grappling_Hook_Arrow)	
		if(arrow != noone)
		{
		if(!arrow.in_flight && !arrow.returning)
		{
			player_state = 2 //set movement state to grappling	
		}
		}
	}
	if(graple_release && can_control){
		var arrow = instance_nearest(x,y,OBJ_Grappling_Hook_Arrow)
		if(arrow != noone)
		{
		arrow.returning = true
		}
	}
	if(shoot && can_shoot && can_control){
		
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
		
	//calculate gravity
	if(wall_slide)
	{
		if(y_velocity > wall_slide_speed)
		{
			y_velocity = wall_slide_speed
		}
		else if(y_velocity < 0)
		{
			y_velocity = 0	
		}
		else{
			y_velocity += OBJ_Game_Controller_Player.gravity
		}
	}
	else if(y_velocity < max_fall_speed)
	{
		y_velocity += OBJ_Game_Controller_Player.gravity
		
		if(y_velocity > max_fall_speed)
		{
			y_velocity = max_fall_speed	
		}	
	}
		
	//updates player's position
	predicted_x = x+x_velocity
	predicted_y = y+y_velocity

	//x position
	xcollison = instance_place(predicted_x,y,OBJ_Floor_Master)

	move_and_collide(x_velocity,0,OBJ_Floor_Master)

	//y position
	ycollison = instance_place(x,predicted_y,OBJ_Floor_Master)

	if(ycollison != noone)
	{
		move_and_collide(0,y_velocity,OBJ_Floor_Master)
		y_velocity = 0
		grounded = true
		can_dash = true
	}
	else
	{
		move_and_collide(0,y_velocity,OBJ_Floor_Master)
	}
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
	move_and_collide(x_velocity,0,OBJ_Floor_Master)
	break;

	case 2: //grappling
	
	var arrow = instance_nearest(x,y,OBJ_Grappling_Hook_Arrow)
	if(!graple_hold) //if the player lets go of the key
	{
		player_state =0	//return to normal movement
		arrow.returning = true	
	}
	else
	{
		grounded = false
		
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

		//updates player's position
		 predicted_x = x+x_velocity
		 predicted_y = y+y_velocity

		//x position
		xcollison = instance_place(predicted_x,y,OBJ_Floor_Master)
		var xgrcollison = instance_place(predicted_x,y,OBJ_Grappling_Hook_Arrow)

		move_and_collide(x_velocity,0,OBJ_Floor_Master)

		//y position
		ycollison = instance_place(x,predicted_y,OBJ_Floor_Master)
		var ygrcollison = instance_place(x,predicted_y,OBJ_Grappling_Hook_Arrow)

		if(ycollison != noone)
		{
			move_and_collide(0,y_velocity,OBJ_Floor_Master)
			y_velocity = 0
			grounded = true
		}
		else
		{
			move_and_collide(0,y_velocity,OBJ_Floor_Master)
		}
		
		if(instance_place(x,y,OBJ_Grappling_Hook_Arrow))
		{
			move_and_collide(0,y_velocity,OBJ_Floor_Master)
			move_and_collide(0,y_velocity,OBJ_Floor_Master)
			instance_destroy(arrow)
			player_state = 3
		}
		if(shoot && can_shoot){
		
		can_shoot = false
		alarm[2] = .25 * game_get_speed(gamespeed_fps)
		
		var gy = mouse_y
		var gx = mouse_x

		var bullet = instance_create_layer(OBJ_Player.x,OBJ_Player.y,"instances",OBJ_Bullet)

		relative_x = gx-x
		relative_y = gy-y

		trajectory = point_direction(gx,gy,x,y)
		radiens = (trajectory - 90) * (pi/180)

		x_multiplier = sin(radiens)
		y_multiplier = cos(radiens)

		bullet.direction = trajectory
		bullet.image_angle = bullet.direction -180
		bullet.x_velocity = bullet_velocity * x_multiplier
		bullet.y_velocity = bullet_velocity * y_multiplier	
	}
		
	}
	break
	
	case 3:// wall hold, for holding place during grapple
	x_velocity = 0
	y_velocity = 0
	if(!graple_hold) //if the player lets go of the key
	{
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
	break
}

ds_list_destroy(hazardList); //delete list to prevent memory leaks