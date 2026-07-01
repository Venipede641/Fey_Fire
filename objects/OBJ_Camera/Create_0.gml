/// @description OBJ_Camera — Create Event

// ── Deadzone ──────────────────────────────────────────────────────────────────
// The deadzone is a rectangle centered in the view. The camera only moves when
// the player steps outside it. Measured in pixels from the view centre.
deadzone_w = 120;  // half-width  — tweak to taste
deadzone_h = 80;   // half-height — tweak to taste

// ── Smoothing ─────────────────────────────────────────────────────────────────
// How quickly the camera catches up once the player leaves the deadzone.
// 1.0 = instant snap. Lower values = smoother but laggier.
cam_lerp = 0.12;

// ── Starting position ─────────────────────────────────────────────────────────
// Initialise the camera centred on the player so there is no jump on frame 1.
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);
cam_x = OBJ_Player.x - _vw / 2;
cam_y = OBJ_Player.y - _vh / 2;
camera_set_view_pos(view_camera[0], cam_x, cam_y);

// ── Parallax layers ───────────────────────────────────────────────────────────
// Add one struct per background layer in your room.
// factor_x / factor_y: how much the layer moves relative to the camera.
//   0.0 = pinned to screen (e.g. a solid sky fill)
//   0.5 = moves at half camera speed (distant mountains)
//   1.0 = moves with the world (not useful for parallax, same as a normal layer)
//
// Layer names must match exactly what you named them in the Room Editor.
// Every layer listed here should have Tile Horizontal enabled in the Room Editor.
parallax_layers = [
    { name : "bg_sky",   factor_x : 0.0,  factor_y : 0.0  },
    { name : "bg_far",   factor_x : 0.15, factor_y : 0.05 },
    { name : "bg_mid",   factor_x : 0.35, factor_y : 0.1  },
    { name : "bg_close", factor_x : 0.65, factor_y : 0.2  },
];
