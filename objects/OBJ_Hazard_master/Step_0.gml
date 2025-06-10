/// @description Insert description here
if(within_interaction_range)
{
	if (!collision_circle(x, y, OBJ_Player.hazard_interaction_range, OBJ_Player, false, true))
	{
	    within_interaction_range = false
	}	
}
if(triggered)
{
	//activation effect goes here
	
	
	
	//
	alarm[0] =  cooldown_length * game_get_speed(gamespeed_fps) //cooldown
	can_activate = false
}