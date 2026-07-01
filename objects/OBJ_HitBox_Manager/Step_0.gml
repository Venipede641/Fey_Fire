// obj_hitbox_manager — Step Event
for (var i = 0; i < ds_list_size(hitbox_list); i++) {
    var hb = hitbox_list[| i];
    if (!hb.active) continue;

    for (var j = 0; j < ds_list_size(hurtbox_list); j++) {
        var hurt = hurtbox_list[| j];
        if (hurt.owner == hb.owner) continue;
        if (hurt.owner.invincible)  continue;
        if (hurt.intangible)        continue;

        if (hitbox_hurtbox_overlap(hb, hurt)) {
            scr_apply_hit(hb, hurt);
            hb.active = false;
            break;
        }
    }
}