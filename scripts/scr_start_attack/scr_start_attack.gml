function scr_start_attack(atk_name) {
    // Validate the attack exists before doing anything
    if (!struct_exists(global.attack_data, atk_name)) {
        show_debug_message("WARNING: attack not found: " + atk_name);
        return;
    }

    current_attack    = atk_name;
    attack_frame      = 0;
    state             = STATE.ATTACKING;

    // Pre-build the spawned tracker sized to this attack's hitbox count
    var hb_count      = array_length(global.attack_data[$ atk_name][$ "hitboxes"]);
    attack_hb_spawned = array_create(hb_count, false);

    // Clear hit IDs from the previous attack
    ds_list_clear(hit_ids_received);
}