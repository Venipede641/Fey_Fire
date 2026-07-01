for (var i = 0; i < ds_list_size(hitbox_list); i++) {
    debug_draw_hitbox(hitbox_list[| i], c_red);
}
for (var j = 0; j < ds_list_size(hurtbox_list); j++) {
    debug_draw_hitbox(hurtbox_list[| j], c_blue);
}