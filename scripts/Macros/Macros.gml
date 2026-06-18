/// scr_constants
/// @description Global macros for player movement. No code runs here — values only.

// ── Player States ─────────────────────────────────────────────────────────────
#macro STATE_NORMAL 0
#macro STATE_DASH   1
#macro STATE_DIVE   2

// ── Facing ───────────────────────────────────────────────────────────────────
#macro FACING_LEFT  0
#macro FACING_RIGHT 1

// ── Movement Tuning ───────────────────────────────────────────────────────────
#macro GROUND_DECEL        10      // braking force per frame when no key is held
#macro FALL_GRAVITY_MULT   1.5     // gravity multiplier while falling (not rising)
#macro WALL_CHECK_DIST     5       // pixel offset used to probe for an adjacent wall

// ── Dive ─────────────────────────────────────────────────────────────────────
#macro DIVE_SPEED_MAX      50      // initial dive speed magnitude
#macro DIVE_SPEED_MIN      25      // minimum maintained dive speed
#macro DIVE_LAUNCH_Y      -5       // upward kick applied when dive begins
#macro DIVE_DECEL_WITH     1.25    // deceleration multiplier when pressing into dive direction
#macro DIVE_DECEL_AGAINST  0.75    // deceleration multiplier when pressing against dive direction
