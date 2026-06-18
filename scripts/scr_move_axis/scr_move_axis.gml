/// scr_move_axis(vel, is_y, use_platforms)
/// @description Moves the calling instance one pixel at a time along one axis,
///              stopping on the first collision found. Returns the resulting velocity
///              (unchanged if unobstructed, 0 if blocked).
///
///              Runs in the scope of the calling instance, so it reads and writes
///              the caller's x / y directly.
///
/// @param {real}    vel            Current velocity on the axis (pixels per frame, signed)
/// @param {bool}    is_y           true  → Y axis movement
///                                 false → X axis movement
/// @param {bool}    use_platforms  true  → use CollisonChecker (respects one-way platforms)
///                                 false → use CollisonCheckerNoPlat (ignores platforms)
/// @return {real}   Resulting velocity after movement (0 if a wall was hit)

function scr_move_axis(vel, is_y, use_platforms) {
    var _count = abs(vel);
    var _step  = sign(vel);
    var _dx    = is_y ? 0 : _step;
    var _dy    = is_y ? _step : 0;

    repeat (_count) {
        var _hit = use_platforms
            ? CollisonChecker(_dx, _dy)
            : CollisonCheckerNoPlat(_dx, _dy);

        if (!_hit) {
            x += _dx;
            y += _dy;
        } else {
            return 0; // blocked — caller should zero out the matching velocity
        }
    }
    return vel; // unobstructed — velocity is unchanged
}

