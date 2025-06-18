extends Node

# Audio
var bgmVolume: float = 0.2 # Default Lautstärke: Hintergrundmusik
var sfxVolume: float = 0.2 # Default Lautstärke: Soundeffekte

# Spiel
var gameSettings = {
	"easy": {"rounds": 10, "roundDuration": 240, "min_enemies": 10, "max_enemies": 20, "enemy_types": "", "enemy_level": 1, "waves": 3},
	"medium": {"rounds": 11, "roundDuration": 240, "min_enemies": 20, "max_enemies": 30, "enemy_types": "", "enemy_level": 2, "waves": 5},
	"hard": {"rounds": 12, "roundDuration": 240, "min_enemies": 30, "max_enemies": 40, "enemy_types": "", "enemy_level": 3, "waves": 7}
	}
var default_gameSetting = "easy"
var safeZoneSettings = {"radius": 250.0, "visualize": true}
var enemySpawnZoneSettings = {"radius": 500.0, "visualize": true}
