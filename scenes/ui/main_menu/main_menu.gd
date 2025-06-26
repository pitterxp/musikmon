extends Control

func _ready() -> void:
	UiController.setup_ui_buttons_in_scene()
	
	# Check for userprofile & autoload player_id
	PlayerService.load_profile()
	if RuntimeParameter.player_id > 0:
		var player_tag = preload("res://scenes/ui/templates/ui_player_profil_tag/ui_player_profil_tag.tscn").instantiate()
		add_child(player_tag)

func _on_options_pressed() -> void:
	UiController.goto_ui_scene(UiController.OPTIONS_MENU)

func _on_player_profiles_pressed() -> void:
	UiController.goto_ui_scene(UiController.PLAYER_PROFILE)

func _on_monpedia_pressed() -> void:
	UiController.goto_ui_scene(UiController.MUSIKMON_PEDIA)

func _on_adventure_pressed() -> void:
	UiController.goto_ui_scene(UiController.PRE_ADVENTURE)

func _on_idle_pressed() -> void:
	UiController.goto_ui_scene(UiController.PRE_QWISIDLE)
