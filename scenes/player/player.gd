extends CharacterBody2D


const SPEED = 300.0
#const JUMP_VELOCITY = -400.0


func _physics_process(_delta: float) -> void:
	"""
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	"""
	
	# Bewegung holen
	var h := Input.get_axis("move_left", "move_right")
	var v := Input.get_axis("move_up", "move_down")
	
	# Richtung & Geschwindigkeit
	velocity = Vector2(h, v).normalized() * SPEED
	
	# Bewegung ausführen – Godot-Kollisionssystem regelt
	move_and_slide()
