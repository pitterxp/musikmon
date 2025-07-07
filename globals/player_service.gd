# player_service.gd
extends Node

func load_profile() -> void:
	var player_id = DB.load_player_profile()
	if player_id <= 0:
		player_id = check_playerid()
	RuntimeParameter.player_id = player_id

func check_playerid() -> int:
	var player_id: int = RuntimeParameter.player_id
	
	if player_id < 0:
		# INVALID player_id
		#print("❌ no player profile present in 'RuntimeParameter'")
		
		# Loading profile from DB
		player_id = DB.load_player_profile()
		
		if player_id < 0:
			#printerr("🆕 DB => user MUST create new profile")
			show_nickname_popup()
			
		else:
			#print("✅ successfully loaded 🧍 profile ID#", player_id)
			RuntimeParameter.player_id = player_id
	else:
		# VALID player_id
		#print("✅ valid player profile present!")
		return player_id
		
	return player_id
	
func show_nickname_popup():
	var popup = preload("res://scenes/ui/templates/ui_input_nickname/ui_input_nickname.tscn").instantiate()
	add_child(popup)
	# popup.size = Vector2(300, 150)
	
	# Popup zentrieren und anzeigen
	popup.popup_centered()
	
	# Falls dein ui_input_nickname.tscn von Popup erbt

func has_three_starter_mons() -> int:
	if RuntimeParameter.player_id <= 0:
		load_profile()
	
	var player_startermon_count:int = DB.player_has_startermon(RuntimeParameter.player_id)
	if player_startermon_count == 3:
		# AllGood => 3 startermon were chosen
		return 3
	else:
		# Player has to choose more startermon
		return player_startermon_count
	
func is_valid_nickname(nickname: String) -> Array:
	var trimmed_nickname = nickname.strip_edges()

	# 1. Leere oder nur Leerzeichen bestehende Nicknames verhindern
	if trimmed_nickname.is_empty():
		print("Der Nickname darf nicht leer sein.")
		return [false, "Der Nickname darf nicht leer sein."]

	# 2. Längenbegrenzung (z.B. 3 bis 32 Zeichen)
	if trimmed_nickname.length() < 3 or trimmed_nickname.length() > 32:
		print("Der Nickname muss zwischen 3 und 32 Zeichen lang sein.")
		return [false, "Der Nickname muss zwischen 3 und 32 Zeichen lang sein." ]

	return [true, trimmed_nickname]
	

# Hilfsfunktion, solange img file paths in der DB noch nicht finalisiert sind
func img_path(img_name:String, img_size:int) -> String:
	var ico = "res://scenes/humans/various/"+img_name+"/img/"+img_name+"_%d.png" % img_size
	return ico

# # #
# INGAME 
# # #
