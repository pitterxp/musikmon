extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_mainmenu_pressed() -> void:
	UiController.goto_ui_scene(UiController.INTRO)


func _on_play_pressed() -> void:
	pass # Replace with function body.
