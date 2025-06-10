/// @description Insert description here
// You can write your code in this editor
draw_self()
if(within_interaction_range)
{
	draw_set_font(FNT_hazard_display_font)
	draw_set_color(c_black)
	draw_set_halign(fa_center)
	draw_text(x, y - 150, hazard_name)
}
