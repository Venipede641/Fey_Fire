//various scripts for overlaping hitboxes and hurtboxes

// ─── RECT vs RECT ────────────────────────────────────────────────────────────
function rect_rect_overlap(a, b) {
    var ax = a.owner.x + a.x;
    var ay = a.owner.y + a.y;
    var bx = b.owner.x + b.x;
    var by = b.owner.y + b.y;

    return (ax        < bx + b.w)
        && (ax + a.w  > bx)
        && (ay        < by + b.h)
        && (ay + a.h  > by);
}

// ─── CIRCLE vs CIRCLE ────────────────────────────────────────────────────────
function circle_circle_overlap(a, b) {
    var ax = a.owner.x + a.x;
    var ay = a.owner.y + a.y;
    var bx = b.owner.x + b.x;
    var by = b.owner.y + b.y;

    var dx      = ax - bx;
    var dy      = ay - by;
    var r_sum   = a.radius + b.radius;

    return (dx*dx + dy*dy) < (r_sum * r_sum);
}

// ─── CIRCLE vs RECT ──────────────────────────────────────────────────────────
function circle_rect_overlap(circ, rect) {
    var cx = circ.owner.x + circ.x;
    var cy = circ.owner.y + circ.y;
    var rx = rect.owner.x + rect.x;
    var ry = rect.owner.y + rect.y;

    // Closest point on rect to circle center
    var closest_x = clamp(cx, rx, rx + rect.w);
    var closest_y = clamp(cy, ry, ry + rect.h);

    var dx = cx - closest_x;
    var dy = cy - closest_y;

    return (dx*dx + dy*dy) < (circ.radius * circ.radius);
}

// ─── CAPSULE HELPERS ─────────────────────────────────────────────────────────

// Squared distance from point (px,py) to segment (ax,ay)→(bx,by)
function point_segment_dist_sq(px, py, ax, ay, bx, by) {
    var dx = bx - ax;
    var dy = by - ay;
    var len_sq = dx*dx + dy*dy;

    if (len_sq == 0) {
        // Segment is a point
        var ex = px - ax;
        var ey = py - ay;
        return ex*ex + ey*ey;
    }

    // Project point onto segment, clamped to [0,1]
    var t  = clamp(((px-ax)*dx + (py-ay)*dy) / len_sq, 0, 1);
    var nx = ax + t*dx - px;
    var ny = ay + t*dy - py;

    return nx*nx + ny*ny;
}

// World-space capsule endpoints (handles facing direction)
function capsule_world_points(cap) {
    var facing = cap.owner.image_xscale >= 0 ? 1 : -1;
    return {
        x1: cap.owner.x + cap.x1 * facing,
        y1: cap.owner.y + cap.y1,
        x2: cap.owner.x + cap.x2 * facing,
        y2: cap.owner.y + cap.y2,
    };
}

// ─── CAPSULE vs CAPSULE ──────────────────────────────────────────────────────
function capsule_capsule_overlap(a, b) {
    var wa = capsule_world_points(a);
    var wb = capsule_world_points(b);

    // Find closest points between the two segments
    // We sample along segment A and find min dist to segment B
    var min_dist_sq = infinity;
    var steps = 8;  // precision; 8 is plenty for gameplay

    for (var i = 0; i <= steps; i++) {
        var t  = i / steps;
        var px = lerp(wa.x1, wa.x2, t);
        var py = lerp(wa.y1, wa.y2, t);
        var d  = point_segment_dist_sq(px, py, wb.x1, wb.y1, wb.x2, wb.y2);
        if (d < min_dist_sq) min_dist_sq = d;
    }

    var r_sum = a.radius + b.radius;
    return min_dist_sq < (r_sum * r_sum);
}

// ─── CAPSULE vs CIRCLE ───────────────────────────────────────────────────────
function capsule_circle_overlap(cap, circ) {
    var wc = capsule_world_points(cap);
    var cx = circ.owner.x + circ.x;
    var cy = circ.owner.y + circ.y;

    var dist_sq = point_segment_dist_sq(cx, cy, wc.x1, wc.y1, wc.x2, wc.y2);
    var r_sum   = cap.radius + circ.radius;

    return dist_sq < (r_sum * r_sum);
}

// ─── CAPSULE vs RECT ─────────────────────────────────────────────────────────
function capsule_rect_overlap(cap, rect) {
    var wc = capsule_world_points(cap);
    var rx = rect.owner.x + rect.x;
    var ry = rect.owner.y + rect.y;

    // Test several points along the capsule spine against the rect
    // and also check if capsule endpoints are inside rect
    var steps = 8;
    for (var i = 0; i <= steps; i++) {
        var t  = i / steps;
        var px = lerp(wc.x1, wc.x2, t);
        var py = lerp(wc.y1, wc.y2, t);

        // Closest point on rect to this spine point
        var closest_x = clamp(px, rx, rx + rect.w);
        var closest_y = clamp(py, ry, ry + rect.h);

        var dx = px - closest_x;
        var dy = py - closest_y;

        if ((dx*dx + dy*dy) < (cap.radius * cap.radius)) return true;
    }

    return false;
}

function hitbox_hurtbox_overlap(hb, hurt) {
    // hb:   can be rect, circle, or capsule
    // hurt: can only be rect or capsule

    switch (hb.shape) {
        case "rect":
            if (hurt.shape == "rect")    return rect_rect_overlap(hb, hurt);
            if (hurt.shape == "capsule") return capsule_rect_overlap(hurt, hb);
            break;

        case "circle":
            if (hurt.shape == "rect")    return circle_rect_overlap(hb, hurt);
            if (hurt.shape == "capsule") return capsule_circle_overlap(hurt, hb);
            break;

        case "capsule":
            if (hurt.shape == "rect")    return capsule_rect_overlap(hb, hurt);
            if (hurt.shape == "capsule") return capsule_capsule_overlap(hb, hurt);
            break;
    }

    return false;
}