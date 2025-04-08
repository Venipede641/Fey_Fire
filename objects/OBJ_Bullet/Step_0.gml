/// @description Insert description here
// You can write your code in this editor
var predicted_x = x+x_velocity
	var predicted_y = y+y_velocity

	//x position
	var xcollison = instance_place(predicted_x,y,OBJ_Floor_Master)

	if(xcollison != noone)
	{
		instance_destroy(self)
	}
	move_and_collide(x_velocity,0,OBJ_Floor_Master)

	//y position
	var ycollison = instance_place(x,predicted_y,OBJ_Floor_Master)

	if(ycollison != noone)
	{
		instance_destroy(self)
	}
	move_and_collide(0,y_velocity,OBJ_Floor_Master)