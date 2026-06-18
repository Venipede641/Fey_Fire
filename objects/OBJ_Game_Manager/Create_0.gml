/// @description creates hud and pauses [TO-DO]
paused = false;

//open Attacks JSON
var file = file_text_open_read("attacks.json");
var json_string = "";
while (!file_text_eof(file)) {
    json_string += file_text_readln(file);
}
file_text_close(file);

global.attack_data = json_parse(json_string);