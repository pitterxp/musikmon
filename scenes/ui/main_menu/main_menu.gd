extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_options_pressed() -> void:
	UiController.goto_ui_scene(UiController.OPTIONS_MENU)



func _on_monpedia_pressed() -> void:
	UiController.goto_ui_scene(UiController.MUSIKMON_PEDIA)



func _on_adventure_pressed() -> void:
	UiController.goto_ui_scene(UiController.PRE_ADVENTURE)


func _on_idle_pressed() -> void:
	UiController.goto_ui_scene(UiController.PRE_QWISIDLE)
