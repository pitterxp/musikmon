extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiController.setup_ui_buttons_in_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	UiController.goto_ui_scene(UiController.MAIN_MENU)


func _on_mainmenu_pressed() -> void:
	UiController.goto_ui_scene(UiController.MAIN_MENU)
