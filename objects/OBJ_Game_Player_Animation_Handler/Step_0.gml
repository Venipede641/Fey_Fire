/// @description perform logic on player's current animation state

// animation state key
// 0: idle
// 1: running

var player = instance_nearest(x,y,OBJ_Player) //get player instance to check if it exists and for later operations
if(player != noone)
{
	if(player.grounded){
		if(player.x_velocity != 0)	
		{
			animation_state = 1	//running
		}
		else
		{
			animation_state = 0 //idle	
		}
	}
	else{
			animation_state = -1 //no anamation created
	}
}