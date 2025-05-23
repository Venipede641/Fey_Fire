/// @description Insert description here
// You can write your code in this editor
draw_set_color(c_black)
draw_set_font(FNT_debug)
draw_set_halign(fa_left)
draw_text(50,50,"player x: \n" + string(OBJ_Player.x_velocity))
draw_text(50,100,"player y: \n" + string(OBJ_Player.y_velocity))
draw_text(50,150,"player state: \n" + string(OBJ_Player.player_state))
draw_text(50,200,"postdrag enable: \n" + string(OBJ_Player.post_dash_drag_enabled))
draw_text(50,250,"animation state: \n" + string(OBJ_Game_Player_Animation_Handler.animation_state))
draw_text(50,300,"player bbox bottem: \n" + string(OBJ_Player.bbox_bottom))
draw_text(50,350,"player y: \n" + string(OBJ_Player.y))