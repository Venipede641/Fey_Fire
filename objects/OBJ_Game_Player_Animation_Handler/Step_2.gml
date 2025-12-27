/// @description apply animation

var player = instance_nearest(x,y,OBJ_Player)

if(player.facing == 1){
	 player.image_xscale = 1	
}
else{
	player.image_xscale = -1	
}

if(player != noone)
{
	switch(animation_state)
	{
		//insert animations as you get them
		case 0:
		player.sprite_index = SPR_Jade_Idle
		break
		
		case 1:
		player.sprite_index = SPR_Jade_run
		break
		
		case 2:
		player.sprite_index = SPR_Jade_jump_rising
		break
		
		case 3:
		player.sprite_index = SPR_Jade_jump_falling
		break
		
		case 4:
		player.sprite_index = SPR_Jade_dive_Temp
		break
		
		default:
		player.sprite_index = SPR_Player_Temp
		break

	}
}
