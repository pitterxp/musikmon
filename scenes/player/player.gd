extends CharacterBody2D

const SPEED = 300.0
var player_id : int = RuntimeParameter.player_id
var player_data

func _ready() -> void:
	# Always check for player_id ^.^
	if player_id <= 0:
		PlayerService.load_profile()
		player_id = RuntimeParameter.player_id
	
	# Initialize stuff
	initialize_player()

func initialize_player() -> void:
	# Fetch Player data
	var res = DB.load_player_runtime_data(player_id)
	if res[0] == true:
		player_data = res[1][0]
		#print("Succesfully loaded player data from DB")
		#print(player_data)
	else:
		print(res[1])
	
	# Player Sprite
	set_player_sprite()

func set_player_sprite(asset_id:int = 0) -> void:
	if asset_id == 0:
		#print("Loading default player asset")
		var img: String = PlayerService.img_path(player_data['charakter_avatar'], 64)
		$Sprite2D.texture = load(img)
	else:
		print("Load specified player asset")

func _physics_process(_delta: float) -> void:	
	#  Get Movement
	var h := Input.get_axis("move_left", "move_right")
	var v := Input.get_axis("move_up", "move_down")
	

	# Flip sprite horizontally
	if h < 0:
		$Sprite2D.flip_h = false  # left = default
	elif h > 0:
		$Sprite2D.flip_h = true
	
	"""
	 # Flip sprite vertically xD
	if v < 0:
		$Sprite2D.flip_v = true
	elif v > 0:
		$Sprite2D.flip_v = false
	"""

	# Direction + Speed
	velocity = Vector2(h, v).normalized() * SPEED
	
	# Bewegung ausführen – Godot-Kollisionssystem regelt
	move_and_slide()
