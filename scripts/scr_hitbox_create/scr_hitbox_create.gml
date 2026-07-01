function Hitbox(_owner, _data) constructor {
    owner   = _owner;
    active  = true;
    hit_ids = ds_list_create();  // targets already hit by this box

    // Combat properties
    damage      = _data[$ "damage"]      ?? 0;
    base_kb     = _data[$ "base_kb"]     ?? 20;
    kb_angle    = _data[$ "kb_angle"]    ?? 45;
    hitstun     = _data[$ "hitstun"]     ?? 8;
    hit_id      = _data[$ "hit_id"]      ?? 0;

    // Shape
    shape = _data[$ "shape"] ?? "rect";

    switch (shape) {
        case "rect":
            x = _data[$ "x"] ?? 0;
            y = _data[$ "y"] ?? 0;
            w = _data[$ "w"] ?? 32;
            h = _data[$ "h"] ?? 32;
            break;

        case "circle":
            x      = _data[$ "x"]      ?? 0;   // center offset from owner
            y      = _data[$ "y"]      ?? 0;
            radius = _data[$ "radius"] ?? 16;
            break;

        case "capsule":
            x1     = _data[$ "x1"]     ?? 0;   // start point offset from owner
            y1     = _data[$ "y1"]     ?? 0;
            x2     = _data[$ "x2"]     ?? 0;   // end point offset from owner
            y2     = _data[$ "y2"]     ?? -40;
            radius = _data[$ "radius"] ?? 16;
            break;
    }
}