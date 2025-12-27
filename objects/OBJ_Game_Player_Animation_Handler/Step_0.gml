/// @description perform logic on player's current animation state

// animation state key
// 0: idle
// 1: running
// 2: airborne, rising
// 3: airborne, falling
// 4: diving

var player = instance_nearest(x,y,OBJ_Player) //get player instance to check if it exists and for later operations
if(player != noone){
	if(player.player_state == 4){ //diving
			animation_state = 4
	}
	if(player.grounded){
		if(player.x_velocity != 0){
			animation_state = 1	//running
		}
		else{
			animation_state = 0 //idle	
		}
	}
	else{ //then they must be in the air
		if(player.y_velocity < 0){ 
			animation_state = 2 //rising
		}
		else{
			animation_state = 3 //falling
		}
	}
}