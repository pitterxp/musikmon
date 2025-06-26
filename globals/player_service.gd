# player_service.gd
extends Node

func load_profile() -> void:
	var player_id = DB.load_player_profile()
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

func has_three_starter_mons() -> bool:
	if RuntimeParameter.spieler_id == -1:
		return false
	#TODO
	#var result = MusikMonDB.query("SELECT COUNT(*) FROM spieler_inventar_mon WHERE spieler_id = ? AND starter_mon = 1", [RuntimeParameter.spieler_id])
	#return result[0]["COUNT(*)"] >= 3
	return 0
	
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
