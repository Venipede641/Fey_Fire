/// @description movement
// You can write your code in this editor

if(in_flight && !returning)
{
	var predicted_x = x+x_velocity
	var predicted_y = y+y_velocity

	//x position
	var collison = collision_line(x,y,predicted_x,predicted_y,OBJ_Floor_Master,true,true)

	if(collison != noone)
	{
		in_flight = false
	}
	
	move_and_collide(x_velocity,0,OBJ_Floor_Master)
	move_and_collide(0,y_velocity,OBJ_Floor_Master)
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
		var xcollison = instance_place(predicted_x,y,OBJ_Floor_Master)

		if(xcollison != noone)
		{
			in_flight = false
		}
		move_and_collide(x_velocity,0,OBJ_Floor_Master)

		//y position
		var ycollison = instance_place(x,predicted_y,OBJ_Floor_Master)

		if(ycollison != noone)
		{
			in_flight = false
		}
		move_and_collide(0,y_velocity,OBJ_Floor_Master)
	}
}
