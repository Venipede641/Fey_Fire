/// @description Insert description here
// You can write your code in this editor
var arrow = instance_nearest(OBJ_Player.x,OBJ_Player.y,OBJ_Grappling_Hook_Arrow)	
		if(arrow != noone)
		{
		var gy = arrow.y
		var gx = arrow.x

		var relative_x = gx-OBJ_Player.x
		var relative_y = gy-OBJ_Player.y

		var trajectory = point_direction(gx,gy,OBJ_Player.x,OBJ_Player.y)
		var radiens = (trajectory - 90) * (pi/180)

		var x_multiplier = sin(radiens)
		var y_multiplier = cos(radiens)

draw_set_color(c_black)
draw_text(50,50,"mouse x: \n" + string(mouse_x))
draw_text(50,100,"mouse y: \n" + string(mouse_y))
draw_text(50,150,"x dif: \n" + string(relative_x))
draw_text(50,200,"y dif: \n" + string(relative_y))
draw_text(50,250,"angle: \n" + string(trajectory))
draw_text(50,300,"x velocity: \n" + string(x_multiplier * 60))
draw_text(50,350,"y velocity: \n" + string(y_multiplier * 60))
draw_text(50,400,"player state: \n" + string(OBJ_Player.player_state))
		}