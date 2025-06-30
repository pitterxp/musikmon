extends Control

func _ready() -> void:
	UiController.setup_ui_buttons_in_scene()
	
	PlayerService.load_profile()
	if RuntimeParameter.player_id > 0:
		var player_tag = preload("res://scenes/ui/templates/ui_player_profil_tag/ui_player_profil_tag.tscn").instantiate()
		add_child(player_tag)

func _on_mainmenu_pressed() -> void:
	UiController.goto_ui_scene(UiController.MAIN_MENU)


func _on_play_pressed() -> void:
	pass # Replace with function body.
