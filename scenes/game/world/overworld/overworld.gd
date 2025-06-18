extends Node2D


func _ready() -> void:	
	if RuntimeParameter.overworldmap_last_player_position != Vector2.ZERO:
		$Level/Spieler.global_position = RuntimeParameter.overworldmap_last_player_position

func _process(_delta: float) -> void:
	pass
