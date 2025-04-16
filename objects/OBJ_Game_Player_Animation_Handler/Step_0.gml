/// @description perform logic on player's current animation state

// animation state key
// 0: idle emptyhanded
// 1: walk emptyhanded
// 2: airborne rising emptyhanded
// 3: airborne falling emptyhanded
// 4: grappling emptyhanded
// 5: dashing emptyhanded
// 6: wallslide emptyhanded
// 7: idle pistol
// 8: walk pistol
// 9: airborne rising pistol
// 10: airborne falling pistol
// 11: grappling pistol
// 12: dashing pistol
// 13: wallslide pistol
// 14: idle bow
// 15: walk bow
// 16: airborne rising bow
// 17: airborne falling bow
// 18: grappling bow
// 19: dashing bow
// 20: wallslide bow

var player = instance_nearest(x,y,OBJ_Player) //get player instance to check if it exists and for later operations
if(player != noone)
{
	if (player.wall_slide == true )
	{
		animation_state = 6
	}
	else if(player.player_state == 1)
	{
		animation_state = 5
	}
	else if(player.player_state == 2)
	{
		animation_state = 4
	}
	else if(player.y_velocity != 0)
	{
		if(player.y_velocity > 0)
		{
			animation_state = 3
		}
		else
		{
			animation_state = 2
		}
	}
	else if(player.x_velocity != 0)
	{
		animation_state = 1	
	}
	else
	{
		animation_state = 0
	}
	animation_state += player.current_weapon * animation_count
}