/// @description gather data for movement step
// You can write your code in this editor
grounded = CollisonChecker(0,1)
if(grounded == true)
{
	soft_grounded = true
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
