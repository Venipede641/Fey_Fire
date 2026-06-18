// Check every hitbox against every hurtbox
for (var i = 0; i < ds_list_size(hitbox_list); i++) {
    var hb = hitbox_list[| i];
    if (!hb.active) continue;

    for (var j = 0; j < ds_list_size(hurtbox_list); j++) {
        var hurt = hurtbox_list[| j];
        if (hurt.owner == hb.owner) continue;  // don't hit yourself

        // AABB rectangle overlap test
        var hb_world_x = hb.owner.x + hb.x;
        var hb_world_y = hb.owner.y + hb.y;
        var hurt_world_x = hurt.owner.x + hurt.x;
        var hurt_world_y = hurt.owner.y + hurt.y;

        if (rectangle_in_rectangle(
            hb_world_x,   hb_world_y,   hb_world_x   + hb.w,   hb_world_y   + hb.h,
            hurt_world_x, hurt_world_y, hurt_world_x + hurt.w, hurt_world_y + hurt.h
        ) == 1) {
            scr_apply_hit(hb, hurt);
            hb.active = false;  // hitbox consumed (or keep active for multi-hit)
        }
    }
}