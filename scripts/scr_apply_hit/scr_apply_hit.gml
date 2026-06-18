function scr_apply_hit(hb, hurt) {
    var target = hurt.owner;

    // Check if target already got hit by this hitbox this attack
    if (ds_list_find_index(target.hit_ids_received, hb.hit_id) != -1) return;
    ds_list_add(target.hit_ids_received, hb.hit_id);

    // Is the target blocking?
    if (target.is_blocking) {
        target.hitstun_timer = hb.blockstun;
        if (hb.guard_break) target.is_blocking = false;
        // reduced chip damage, etc.
        return;
    }

    // Apply damage + stun
    target.hp           -= hb.damage;
    target.hitstun_timer = hb.hitstun;
    target.hspeed        = hb.knockback_x * sign(target.x - hb.owner.x);
    target.vspeed        = hb.knockback_y;

    if (hb.launch) {
        target.state = STATE.LAUNCHED;
    } else {
        target.state = STATE.HIT;
    }
}
