# (kann mehrfach verwendet werden)
extends Area2D

@export var target_scene: String
var player_in_range: bool = false

func _on_body_entered(body: Node) -> void:
	#print("body entered")
	if body.name == "Spieler":
		player_in_range = true
		body.get_node("InteractionLabel").visible = true

func _on_body_exited(body: Node) -> void:
	#print("body exited")
	if body.name == "Spieler":
		player_in_range = false
		body.get_node("InteractionLabel").visible = false

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("user_action_accept"):
		AudioManager.play_sfx("door-open-close-45475")
		call_deferred("_switch_scene")

func _switch_scene():
	var player_pos = $"../../Level/Spieler".global_position
	#print(player_pos)
	RuntimeParameter.overworldmap_last_player_position = player_pos	
	UiController.goto_game_scene(target_scene)
