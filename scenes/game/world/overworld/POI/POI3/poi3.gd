extends Node

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass

func _on_exit_button_pressed() -> void:
	UiController.goto_game_scene(UiController.OVERWORLD)
