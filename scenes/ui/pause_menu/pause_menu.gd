extends CanvasLayer


func _ready() -> void:
	UiController.setup_ui_buttons_in_scene()
	PauseManager.pause_game()

func _on_continue_pressed() -> void:
	PauseManager.resume_game()
	queue_free()

func _on_mainmenu_pressed() -> void:
	PauseManager.resume_game()
	queue_free()
	UiController.goto_ui_scene(UiController.MAIN_MENU)
