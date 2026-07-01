function debug_draw_hitbox(hb, col) {
    draw_set_color(col);
    draw_set_alpha(0.35);

    switch (hb.shape) {
        case "rect":
            var rx = hb.owner.x + hb.x;
            var ry = hb.owner.y + hb.y;
            draw_rectangle(rx, ry, rx + hb.w, ry + hb.h, false);
            break;

        case "circle":
            var cx = hb.owner.x + hb.x;
            var cy = hb.owner.y + hb.y;
            draw_circle(cx, cy, hb.radius, false);
            break;

        case "capsule":
            var wc = capsule_world_points(hb);
            // Draw the spine
            draw_line_width(wc.x1, wc.y1, wc.x2, wc.y2, hb.radius * 2);
            // Draw the end caps
            draw_circle(wc.x1, wc.y1, hb.radius, false);
            draw_circle(wc.x2, wc.y2, hb.radius, false);
            break;
    }

    draw_set_alpha(1);
}