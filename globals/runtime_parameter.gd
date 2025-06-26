extends Node

# hat user das intro bereits gesehen?
var intro_first_time: bool = true

# User Auswahl: Schwierigkeitsgrad
var difficulty_setting: String = ""

# PLAYER
# => DB spieler.id  =>  Game player_id <=
var player_id: int = -1

# Player.Inventory
# (1) MusikMon
var player_inventory_musikmon = {}

# Overworld Map
# Last Player Postion
var overworldmap_last_player_position : Vector2
