hitbox_list  = ds_list_create();  // active attack hitboxes
hurtbox_list = ds_list_create();  // active hurtboxes

//define functions
function register_hitbox(hb)  { ds_list_add(hitbox_list,  hb); }
function register_hurtbox(hb) { ds_list_add(hurtbox_list, hb); }
function clear_hitboxes()     { ds_list_clear(hitbox_list);     }