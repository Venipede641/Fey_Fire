/// @description Insert description here
// You can write your code in this editor
	var _move_count = abs(x_velocity);
	var _move_once = sign(x_velocity);


// This runs a loop, which runs 'move_count' times. All code in this block is repeated that many amount of times.
repeat (_move_count){
	var _collision_found = CollisonChecker(_move_once, 0);

	// This checks if collision_found is false, meaning a collision was not found, and the player is free to move once on the X axis.
	if (!_collision_found){
		x += _move_once;
	}
	// This 'else' block runs if a collision was found.
	else{
		x_velocity = 0;
		instance_destroy(self)
		break;
	}
}

// We now repeat all of the previous steps to check for collisions on the Y axis.
var _move_count = abs(y_velocity);
var _move_once = sign(y_velocity);

// This runs a loop, which runs 'move_count' times. All actions attached to this are repeated that many amount of times.
repeat (_move_count){
	var _collision_found = CollisonChecker(0, _move_once);

	// This checks if collision_found is false, meaning a collision was not found, and the player is free to move once on the Y axis.
	if (!_collision_found){
		// In that case, move_once is added to the Y coordinate of the character.
		y += _move_once;
	}
	// This 'else' block runs if a collision was found.
	else{
		// In that case, we reset the Y velocity to 0, so the character stops its movement on that axis.
		y_velocity = 0;
		instance_destroy(self)
		break;
	}
}
	
	y = round(y)
	x = round(x)
	