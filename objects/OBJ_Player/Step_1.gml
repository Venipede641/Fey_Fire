/// @description gather data for movement step
// You can write your code in this editor

var space = keyboard_check_pressed(vk_space)
var left = keyboard_check(ord("A"))
var left_arrow = keyboard_check(vk_left)
var right = keyboard_check(ord("D"))
var right_arrow = keyboard_check(vk_right)
var down = keyboard_check(ord("S"))
var down_arrow = keyboard_check(vk_down)
var up_arrow = keyboard_check(vk_up)
var graple_start = keyboard_check_pressed(ord("Q"))
var graple_hold = keyboard_check(ord("Q"))
var graple_release = keyboard_check_released(ord("Q"))
var shift = keyboard_check_pressed(vk_shift)
var shoot = mouse_check_button(mb_left)
var attack = mouse_check_button(ord("A"))

grounded = CollisonChecker(0,1)
if(grounded == true)
{
	soft_grounded = true
	soft_grounded_flag = false
	can_dash = true
	jump_repeat_cur = 0
}
else
{
	if(!soft_grounded_flag)
	{
		alarm[4] = .1 * game_get_speed(gamespeed_fps) //coyote time to allow player to jump slightly after not being grounded
	}
	soft_grounded_flag = true
}
if(y_velocity > 0)
{
	falling = true	
}
else{
	falling = false	
}
