/// @description handles player movement
// You can write your code in this editor
var space = keyboard_check(vk_space)
var left = keyboard_check(ord("A"))
var right = keyboard_check(ord("D"))
var graple_start = keyboard_check_pressed(ord("Q"))
var graple_hold = keyboard_check(ord("Q"))
var shift = keyboard_check_pressed(vk_shift)

var predicted_x
var predicted_y
var xcollison 
var ycollison

//player state, tracks what the player is doing and how to move them
//0 = normal movement
//1 = dashing
//2 = grappling
switch(player_state)
{
case 0:

	if(left)
	{
		x_velocity = -OBJ_Game_Controller_Player.player_move_speed
		facing = 0 //facing left
	}

	if(right)
	{
		x_velocity = OBJ_Game_Controller_Player.player_move_speed
		facing = 1 //facing right
	}

	if(!right&&!left)
	{
		x_velocity = 0
	}

	if(space && grounded)
	{
		y_velocity += OBJ_Game_Controller_Player.player_jump_power
		grounded = false
	}

	y_velocity += OBJ_Game_Controller_Player.gravity

	if(shift&&can_dash)
	{
		player_state = 1 //enters dash movement
		can_dash = false // locks player out of dashing until they hit the ground again
		alarm[0] = .1 * game_get_speed(gamespeed_fps) //alarm to set dashing to false
	}
	
	if(graple_start)
		{
		var gy = mouse_y
		var gx = mouse_x

		var arrow = instance_create_layer(OBJ_Player.x,OBJ_Player.y,"instances",OBJ_Grappling_Hook_Arrow)

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
	
	if(graple_hold)
	{
		var arrow = instance_nearest(x,y,OBJ_Grappling_Hook_Arrow)	
		if(!arrow.in_flight)
		{
			player_state = 2 //set movement state to grappling	
		}
	}
	else{
		instance_destroy(OBJ_Grappling_Hook_Arrow)
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
	if(!graple_hold) //if the player lets go of the key
	{
		player_state =0	//return to normal movement
	}
	else
	{
		var arrow = instance_nearest(x,y,OBJ_Grappling_Hook_Arrow)	
		
		var gy = arrow.x
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

		move_and_collide(x_velocity,0,OBJ_Floor_Master)

		//y position
		ycollison = instance_place(x,predicted_y,OBJ_Floor_Master)

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
	}
	break
}