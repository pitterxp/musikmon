extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiController.setup_ui_buttons_in_scene()
	
	PlayerService.load_profile()
	if RuntimeParameter.player_id > 0:
		var player_tag = preload("res://scenes/ui/templates/ui_player_profil_tag/ui_player_profil_tag.tscn").instantiate()
		add_child(player_tag)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_mainmenu_pressed() -> void:
	UiController.goto_ui_scene(UiController.MAIN_MENU)


func _on_intro_pressed() -> void:
	UiController.goto_ui_scene(UiController.INTRO)


func _on_credits_pressed() -> void:
	UiController.goto_ui_scene(UiController.CREDITS)
