/// @description handles player movement
// You can write your code in this editor
var space = keyboard_check(vk_space)
var left = keyboard_check(vk_left)
var right = keyboard_check(vk_right)
var shift = keyboard_check(vk_shift)

if(left)
{
	x_velocity = -OBJ_Game_Controller_Player.player_move_speed
}

if(right)
{
	x_velocity = OBJ_Game_Controller_Player.player_move_speed
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

if(shift)
{
	x_velocity = x_velocity* 1.5	
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
}
else
{
	move_and_collide(0,y_velocity,OBJ_Floor_Master)
}