/// @description Insert description here
if(within_interaction_range)
{
	if (!collision_circle(x, y, OBJ_Player.hazard_interaction_range, OBJ_Player, false, true))
	{
	    within_interaction_range = false
	}	
}