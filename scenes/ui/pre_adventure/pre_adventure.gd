extends Control

func _ready() -> void:
	UiController.setup_ui_buttons_in_scene()
	
	$Footer/ButtonSet/Play.disabled = true
	
	PlayerService.load_profile()
	if RuntimeParameter.player_id > 0:
		var player_tag = preload("res://scenes/ui/templates/ui_player_profil_tag/ui_player_profil_tag.tscn").instantiate()
		add_child(player_tag)
		
	load_musikmon_inventory()

func load_musikmon_inventory() -> void:
	var startermon_count := PlayerService.has_three_starter_mons()
	if startermon_count == 3:
		# (Starter) Mon Inventar anzeigen?
		var msg = "🪗 GLHF ❤️‍🔥"
		$Content/Label.text = msg
		$Footer/ButtonSet/Play.disabled = false
	else:
		var msg = "🪗 Bitte _3_ MusikMon zum Start wählen ❤️‍🔥"
		$Content/Label.text = msg
		$Footer/ButtonSet/Play.disabled = true
		$Footer/ButtonSet/Play.tooltip_text = msg
		$Footer/ButtonSet/Monpedia.show()

func _on_mainmenu_pressed() -> void:
	UiController.goto_ui_scene(UiController.MAIN_MENU)


func _on_play_pressed() -> void:
	UiController.goto_game_scene(UiController.GAME)


func _on_monpedia_pressed() -> void:
	UiController.goto_ui_scene(UiController.MUSIKMON_PEDIA)
