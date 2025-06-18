extends Node

# Namen definieren

# ### UI Scenes
const INTRO = "intro"
const MAIN_MENU = "main_menu"
const OPTIONS_MENU = "options_menu"
const MUSIKMON_PEDIA = "musikmon_pedia"
const PRE_ADVENTURE = "pre_adventure"
const PRE_QWISIDLE = "pre_qwisidle"
const CREDITS = "credits"

# ### Game Scenes 
const GAME = "game"
const OVERWORLD = "overworld"
const OVERWORLD_POI1 = "overworld_poi1"
const OVERWORLD_POI2 = "overworld_poi2"
const OVERWORLD_POI3 = "overworld_poi3"
const OVERWORLD_POI4 = "overworld_poi4"
const OVERWORLD_POI5 = "overworld_poi5"
const OVERWORLD_POI6 = "overworld_poi6"


# Pfade definieren und vorladen
var ui_scenes = {
	INTRO: preload("res://scenes/ui/intro/intro.tscn"),
	MAIN_MENU: preload("res://scenes/ui/main_menu/main_menu.tscn"),
	OPTIONS_MENU: preload("res://scenes/ui/options_menu/options_menu.tscn"),
	MUSIKMON_PEDIA: preload("res://scenes/ui/musikmon_pedia/MusikMonDetailView.tscn"),
	CREDITS: preload("res://scenes/ui/credits/credits.tscn"),
	PRE_ADVENTURE: preload("res://scenes/ui/pre_adventure/pre_adventure.tscn"),
	PRE_QWISIDLE: preload("res://scenes/ui/pre_qwisidle/pre_qwisidle.tscn")
}

# Pfade definieren ohne vorzuladen
var game_scenes = {
	OVERWORLD: "res://scenes/game/world/overworld/overworld.tscn",
	OVERWORLD_POI1: "res://scenes/game/world/overworld/POI/POI1/poi1.tscn",
	OVERWORLD_POI2: "res://scenes/game/world/overworld/POI/POI2/poi2.tscn",
	OVERWORLD_POI3: "res://scenes/game/world/overworld/POI/POI3/poi3.tscn",
	OVERWORLD_POI4: "res://scenes/game/world/overworld/POI/POI4/poi4.tscn",
	OVERWORLD_POI5: "res://scenes/game/world/overworld/POI/POI5/poi5.tscn",
	OVERWORLD_POI6: "res://scenes/game/world/overworld/POI/POI6/poi6.tscn"
}

func _ready() -> void:
	pass

# UI Szene wechseln
func goto_ui_scene(scene_name: String) -> void:
	if ui_scenes.has(scene_name):
		await FadeManager.fade_to_black(0.5)
		get_tree().change_scene_to_packed(ui_scenes[scene_name])
		await get_tree().process_frame
		await FadeManager.fade_to_clear(0.5)
	else:
		push_error("UI Szene nicht gefunden: " + scene_name)

# Game Szene wechseln
func goto_game_scene(scene_name:String) -> void:
	if game_scenes.has(scene_name):
		get_tree().change_scene_to_file(game_scenes[scene_name])
	else:
		push_error("Game Szene nicht gefunden:" + scene_name)

func goto_mainmenu() -> bool:
	goto_ui_scene("main_menu")
	return true

# main_ui_button sound setup
func setup_ui_buttons_in_scene():
	await get_tree().process_frame
	
	# Alle Buttons in der "main_ui_button" Gruppe finden
	var buttons = get_tree().get_nodes_in_group("main_ui_button")
	
	for button in buttons:
		if button is Button:
			
			# Quick and dirty:
			button.grab_focus()
			if not button.is_connected("pressed", _on_main_ui_button_pressed):
				button.pressed.connect(_on_main_ui_button_pressed.bind(button))

# main_ui_button sound playing
func _on_main_ui_button_pressed(button):
	# Sound abspielen
	var variation = 0
	if button.has_meta("sound_variation"):
		variation = button.get_meta("sound_variation")
	
	AudioManager.play_ui_button_sound(variation)
		
# Controller -> Fokussteuerung
func set_initial_focus(focus_node_path: NodePath) -> void:
	if focus_node_path:
		var node = get_node_or_null(focus_node_path)
		if node and node.has_method("grab_focus"):
			# Warte einen Frame, damit die UI vollständig geladen ist
			await get_tree().process_frame
			node.grab_focus()
