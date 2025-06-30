extends Node

var is_paused := false
var overlay_ref : Node = null
#const PAUSE_MENU_SCENE := preload("res://scenes/ui/pause_menu/pause_menu.tscn")
const PAUSE_OVERLAY_SCENE := preload("res://scenes/ui/pause_menu/pause_overlay.tscn")


func toggle_pause() -> void:
	if is_paused:
		resume_game()
	else:
		pause_game()

# TODO
# GENERIC PAUSE MANAGER GEFICKE
func pause_game(view_scene_path:String="") -> void:
	if is_paused:
		return
	is_paused = true
	get_tree().paused = true
	
	overlay_ref = PAUSE_OVERLAY_SCENE.instantiate()
	get_tree().root.add_child.call_deferred(overlay_ref)
	overlay_ref.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if view_scene_path != "":
		var scene = load(view_scene_path)
		var view_instance = scene.instantiate()
		overlay_ref.get_node("ViewStack").add_child.call_deferred(view_instance)
		
"""
func pause_game():
	if is_paused:
		return
	is_paused = true
	get_tree().paused = true

	var pause_menu = PAUSE_MENU_SCENE.instantiate()
	get_tree().root.add_child.call_deferred(pause_menu)
"""

func resume_game() -> void:
	if not is_paused:
		return
	is_paused = false
	get_tree().paused = false
