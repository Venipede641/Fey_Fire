/// @description movement
// You can write your code in this editor

if(in_flight)
{
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