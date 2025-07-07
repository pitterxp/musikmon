# game.gd
extends Node

var first_spawn := true
var player_in_range := false
@onready var player:CharacterBody2D = $Spieler

func _ready() -> void:
	# Initial/first player spawn
	var game = get_node("/root/Game")
	player = game.get_player()

	_player_global_spawn()
	
	# Restore player's last overworld position
	# TODO
	# Player Position SYNCH
	if RuntimeParameter.overworldmap_last_player_position != Vector2.ZERO:
		player.global_position = RuntimeParameter.overworldmap_last_player_position


func _player_global_spawn() -> void:
	player.global_position = $world/PlayerSpawnMarker/PlayerSpawnPosition.position
	first_spawn = false

func _input(event):
	if event.is_action_pressed("user_pause_menu"):
		PauseManager.pause_game("res://scenes/ui/pause_menu/pause_menu.tscn")

func get_player() -> CharacterBody2D:
	return $Spieler
