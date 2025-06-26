# (kann mehrfach verwendet werden)
extends Area2D

@export var target_position: Vector2
var player_in_range: bool = false

func _on_portal_entered(body: Node) -> void:
	if body.name == "Spieler":
		player_in_range = true
		body.get_node("InteractionLabel").visible = true


func _on_portal_exited(body: Node) -> void:
	if body.name == "Spieler":
		player_in_range = false
		body.get_node("InteractionLabel").visible = false

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("user_action_accept"):
		# TODO: Teleport Sound?!
		#AudioManager.play_sfx("door-open-close-45475")		
		teleport_player(target_position)		
		#teleport_player($"../../PlayerSpawnMarker/PortalPosition".position)
		
func teleport_player(new_position: Vector2) -> void:
	$"../../Level/Spieler".global_position = new_position
