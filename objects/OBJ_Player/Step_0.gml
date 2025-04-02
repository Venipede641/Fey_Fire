/// @description handles player movement
// You can write your code in this editor
var space = keyboard_check(vk_space)
var left = keyboard_check(vk_left)
var right = keyboard_check(vk_right)
var shift = keyboard_check_pressed(vk_shift)

if(!dashing)
{
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
		dashing = true //enters dash movement
		can_dash = false // locks player out of dashing until they hit the ground again
		alarm[0] = .1 * game_get_speed(gamespeed_fps) //alarm to set dashing to false
	}

	//updates player's position
	predicted_x = x+x_velocity
	predicted_y = y+y_velocity

	//x position
	var xcollison = instance_place(predicted_x,y,OBJ_Floor_Master)

	move_and_collide(x_velocity,0,OBJ_Floor_Master)

	//y position
	var ycollison = instance_place(x,predicted_y,OBJ_Floor_Master)

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
}
else
{
	if(facing == 1) //if facing right
	{
		x_velocity = dash_velocity
	}
	else //facing left
	{
		x_velocity = -dash_velocity
	}
	move_and_collide(x_velocity,0,OBJ_Floor_Master)
}