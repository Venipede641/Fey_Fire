/// @description OBJ_Camera — Step Event

if (!instance_exists(OBJ_Player)) exit;

var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);

// ── Deadzone ──────────────────────────────────────────────────────────────────
// Compute the four edges of the deadzone rectangle in room space.
// The zone is always centred on the current camera position.
var _dead_left   = cam_x + _vw / 2 - deadzone_w;
var _dead_right  = cam_x + _vw / 2 + deadzone_w;
var _dead_top    = cam_y + _vh / 2 - deadzone_h;
var _dead_bottom = cam_y + _vh / 2 + deadzone_h;

// Compute where the camera needs to move so the player sits exactly on the
// breached edge. If the player is inside the zone, target stays at cam_x/y.
var _target_x = cam_x;
var _target_y = cam_y;

if      (OBJ_Player.x > _dead_right)  _target_x = cam_x + (OBJ_Player.x - _dead_right);
else if (OBJ_Player.x < _dead_left)   _target_x = cam_x + (OBJ_Player.x - _dead_left);

if      (OBJ_Player.y > _dead_bottom) _target_y = cam_y + (OBJ_Player.y - _dead_bottom);
else if (OBJ_Player.y < _dead_top)    _target_y = cam_y + (OBJ_Player.y - _dead_top);

// Smoothly move toward the target. When inside the deadzone both targets equal
// cam_x/y so lerp produces no movement at all.
cam_x = lerp(cam_x, _target_x, cam_lerp);
cam_y = lerp(cam_y, _target_y, cam_lerp);

// ── Room bounds clamping ──────────────────────────────────────────────────────
// Prevent the camera from showing space outside the room.
cam_x = clamp(cam_x, 0, room_width  - _vw);
cam_y = clamp(cam_y, 0, room_height - _vh);

// Apply to the view.
camera_set_view_pos(view_camera[0], cam_x, cam_y);

// ── Parallax ──────────────────────────────────────────────────────────────────
// Shift each background layer by a fraction of the camera position.
// A factor of 0 keeps the layer pinned to the screen; higher values make it
// scroll faster and appear closer to the player.
for (var i = 0; i < array_length(parallax_layers); i++) {
    var _layer = parallax_layers[i];
    if (layer_exists(_layer.name)) {
        layer_x(_layer.name, cam_x * _layer.factor_x);
        layer_y(_layer.name, cam_y * _layer.factor_y);
    }
}
