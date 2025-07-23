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
	can_dash = true	
}

if(y_velocity > 0)
{
	falling = true	
}
else{
	falling = false	
}
