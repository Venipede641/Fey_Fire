/// @description gather data for movement step
// You can write your code in this editor
grounded = CollisonChecker(0,1)
if(grounded == true)
{
	can_dash = true	
}

if(y_velocity > 0)
{
	falling = true	
}
else{
	falling = false	
}
