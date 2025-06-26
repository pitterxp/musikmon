extends Node2D


var first_spawn := true
var player_in_range := false

func _ready() -> void:
	# Initial/first player spawn
	if first_spawn:
		_player_global_spawn()
	
	# Restore player's last overworld position
	if RuntimeParameter.overworldmap_last_player_position != Vector2.ZERO:
		$Level/Spieler.global_position = RuntimeParameter.overworldmap_last_player_position

func _process(_delta: float) -> void:
	pass

func _player_global_spawn() -> void:
	$Level/Spieler.global_position = $PlayerSpawnMarker/PlayerSpawnPosition.position
	first_spawn = false
