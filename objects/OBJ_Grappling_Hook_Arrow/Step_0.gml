/// @description movement
// You can write your code in this editor

if(in_flight && !returning)
{
	//x position
	
	var _move_count = abs(x_velocity);
	var _move_once = sign(x_velocity);


// This runs a loop, which runs 'move_count' times. All code in this block is repeated that many amount of times.
repeat (_move_count)
{
	// This calls the check_collision function to check for collisions on the X axis, if moved by the move_once value on that dimension.
	// The Y argument is set to 0, so for this collision there is no Y movement.
	// The result of the function, either true or false, is stored in the 'collision_found' variable, which is temporary.
	var _collision_found = CollisonCheckerNoPlat(_move_once, 0);

	// This checks if collision_found is false, meaning a collision was not found, and the player is free to move once on the X axis.
	if (!_collision_found)
	{
		// In that case, move_once is added to the X coordinate of the character.
		x += _move_once;
	}
	// This 'else' block runs if a collision was found.
	else
	{
		// In that case, we reset the X velocity to 0, so the character stops its movement on that axis.
		x_velocity = 0;
		in_flight = false
	
		// Then we break out of the Repeat loop, as no more collision checks are required.
		break;
	}
}

// We now repeat all of the previous steps to check for collisions on the Y axis.
// Everything is the same, but vel_x is replaced by vel_y, and the check_collision function takes a Y value (its second argument).
var _move_count = abs(y_velocity);
var _move_once = sign(y_velocity);

// This runs a loop, which runs 'move_count' times. All actions attached to this are repeated that many amount of times.
repeat (_move_count)
{
	// This calls the check_collision function to check for collisions on the Y axis, if moved by the move_once value.
	// The result of the function, either true or false, is stored in the 'collision_found' variable, which is temporary.
	var _collision_found = CollisonCheckerNoPlat(0, _move_once);

	// This checks if collision_found is false, meaning a collision was not found, and the player is free to move once on the Y axis.
	if (!_collision_found)
	{
		// In that case, move_once is added to the Y coordinate of the character.
		y += _move_once;
	}
	// This 'else' block runs if a collision was found.
	else
	{
		// In that case, we reset the Y velocity to 0, so the character stops its movement on that axis.
		y_velocity = 0;
		in_flight = false
	
		// Then we break out of the Repeat loop, as no more collision checks are required.
		break;
	}
}
}
else if(returning)
{
	var width = OBJ_Player.sprite_width  /2
	var height = OBJ_Player.sprite_width / 2
	if(x < OBJ_Player.x +width && x > OBJ_Player.x- width && y < OBJ_Player.y +height && y > OBJ_Player.y- height)
		{
			instance_destroy(self)
			OBJ_Player.can_grapple = true
		}
	else
	{
		var gy = OBJ_Player.y
		var gx = OBJ_Player.x

		var relative_x = gx-x
		var relative_y = gy-y

		var trajectory = point_direction(gx,gy,x,y)
		var radiens = (trajectory - 90) * (pi/180)

		var x_multiplier = sin(radiens)
		var y_multiplier = cos(radiens)

		direction = trajectory
		x_velocity = OBJ_Player.Grapling_hook_velocity * x_multiplier
		y_velocity =  OBJ_Player.Grapling_hook_velocity * y_multiplier	
		
		var predicted_x = x+x_velocity
		var predicted_y = y+y_velocity

		//x position
		x += x_velocity

		//y position
		y += y_velocity
	}
}
