extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiController.setup_ui_buttons_in_scene()
	
	PlayerService.load_profile()
	if RuntimeParameter.player_id > 0:
		var player_tag = preload("res://scenes/ui/templates/ui_player_profil_tag/ui_player_profil_tag.tscn").instantiate()
		add_child(player_tag)
		
	load_musikmon_inventory()

func load_musikmon_inventory() -> void:
	var mon_inventory : Dictionary = RuntimeParameter.player_inventory_musikmon
	if mon_inventory.size() > 0:
		for key in mon_inventory:
			#print(key , ": " + mon_inventory[key])
			print(mon_inventory[key])
			$Page/Content/Label.text = ""
	else:
		$Page/Content/Label.text = "🪗 Bitte 3 MusikMon zum Start wählen ❤️‍🔥"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_mainmenu_pressed() -> void:
	UiController.goto_ui_scene(UiController.MAIN_MENU)


func _on_play_pressed() -> void:
	UiController.goto_game_scene(UiController.OVERWORLD)
