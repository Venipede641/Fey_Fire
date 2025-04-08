/// @description Insert description here
// You can write your code in this editor
var arrow = instance_nearest(x,y,OBJ_Grappling_Hook_Arrow)	
if(arrow != noone)
{
    var angle = point_direction(arrow.x, arrow.y, OBJ_Player.x, OBJ_Player.y);
    var spriteWidth = sprite_get_width(SPR_Grapling_Rope);
    var spriteHeight = sprite_get_height(SPR_Grapling_Rope);
    var xoffset = sprite_get_xoffset(SPR_Grapling_Rope);
    var yoffset = sprite_get_yoffset(SPR_Grapling_Rope);
    sprite_set_offset(SPR_Grapling_Rope, 0, 0);

    for (var i = 0, d = point_distance(arrow.x, arrow.y, OBJ_Player.x, OBJ_Player.y); i < d; i += spriteWidth)
    {
        var ropex = arrow.x + (i / d) * (OBJ_Player.x - arrow.x);
        var ropey = arrow.y + (i / d) * (OBJ_Player.y - arrow.y);
 
        if (i + spriteWidth <= d)
            draw_sprite_ext(SPR_Grapling_Rope, 0, ropex, ropey, 1, 1, angle, c_white, draw_get_alpha());
        else
            draw_sprite_general(SPR_Grapling_Rope, 0, 0, 0, d - i, spriteHeight, ropex, ropey, 1, 1, angle, c_white, c_white, c_white, c_white, draw_get_alpha());
    }

    sprite_set_offset(SPR_Grapling_Rope, xoffset, yoffset);
}
