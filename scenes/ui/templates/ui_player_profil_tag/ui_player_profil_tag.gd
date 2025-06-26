extends Control

var player_id : int = RuntimeParameter.player_id

func _ready() -> void:
	pass # Replace with function body.
	if player_id > 0:
		var nickname = DB.get_player_nickname(player_id)
		$".".text = "Profil: " + nickname

func _on_pressed() -> void:
	# TODO
	# Fancy Menu-Stuff
	UiController.goto_ui_scene(UiController.PLAYER_PROFILE)
