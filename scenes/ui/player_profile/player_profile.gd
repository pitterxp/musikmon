extends Control

const PROFILE_TEMPLATE = "res://scenes/ui/templates/ui_player_profile_list/ui_player_profile_list.tscn"
var player_id : int = RuntimeParameter.player_id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# here we always need a player_id
	if player_id < 0:
		player_id = PlayerService.check_playerid()
		
	_setup_profile_list()


func _setup_profile_list() -> void:	
	var profiles: Array = DB.load_player_profiles()	
	
	if profiles[0]:
		profiles = profiles[1]
	
	for key in profiles:
		var profile_id:int = key['id']
		var nickname:String = key['nickname']
		var xp:int = key['xp']
		var currency:int = key['currency']
		var active:bool = key['last_active']
		
		# Template laden
		var template = preload(PROFILE_TEMPLATE).instantiate()
		
		# Template zur GUI hinzufügen
		$Content/ProfileList.add_child(template)
		
		# Daten übergeben
		template.setup_profile_entry(profile_id, nickname, xp, currency, active)
		

func setup_mon_inventory(_profile_id:int) -> void:
	# TODO
	# musikmon_pedia.gd => MusikMon Inventarlogik AUSLAGERN => "mon_inventory_helper.gd"
	pass

func _new_player_profile(new_nickname:String) -> void:
	var ret = PlayerService.is_valid_nickname(new_nickname)
	if ret[0]:
		var new_profile = DB.new_player_profile(ret[1])
		if new_profile > 0:
			# All Good
			RuntimeParameter.player_id = new_profile
			UiController.goto_ui_scene(UiController.PLAYER_PROFILE)
		else:
			print("Ein Profil mit diesem Nicknamen exisitiert bereits.")
	else:
		print("Nickname BAD!")
		print(ret[1])

func _on_mainmenu_pressed() -> void:
	UiController.goto_ui_scene(UiController.MAIN_MENU)


func _on_new_profile_text_submitted(new_text: String) -> void:
	_new_player_profile(new_text)


func _on_add_profile_pressed() -> void:
	var new_nickname:String =  $Content/NewProfile/newProfile.text
	_new_player_profile(new_nickname)


func _on_monpedia_pressed() -> void:
	UiController.goto_ui_scene(UiController.MUSIKMON_PEDIA)
