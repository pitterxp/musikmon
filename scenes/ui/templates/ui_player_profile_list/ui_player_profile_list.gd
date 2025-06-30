extends Control

var player_id : int = RuntimeParameter.player_id
var current_profile : int
var profile_active : bool = false
var profile_to_delete:int = -1

func _ready() -> void:
	pass # Replace with function body.
	

func setup_profile_entry(profile_id:int, nickname:String, xp:int, currency:int, active:bool) -> void:
	var ui_nickname : LineEdit = $nickname
	var ui_xp : Label = $xp
	var ui_currency : Label = $currency
	#var ui_details_btn : Button = $details
	#var ui_del_btn : Button = $details
	
	ui_nickname.text = nickname
	ui_xp.text = "🌟 %d" % xp
	ui_currency.text = "💰 %d" % currency	
	if active:
		profile_active = true
		$active.text = "🗹"
		$active.tooltip_text = "Zuletzt gespielt"
		#$".".modulate = Color.GREEN
		$nickname.modulate = Color.GREEN
	else:
		profile_active = false
		$active.text = "☐"
		$active.tooltip_text = "Profil aktivieren"
	
	set_meta("profile_id", profile_id)
	
func delete_player_profile(profile_id:int) -> void:
	# Set flag
	profile_to_delete = profile_id
	
	var dialog := ConfirmationDialog.new()
	dialog.title = "Profil wirklich löschen?"	
	dialog.dialog_text = "Alle gespeicherten Daten gehen verloren, das Profil wird unwiderruflich gelöscht!"	

	# connect signals
	dialog.canceled.connect (_delete_dialog_canceled)
	dialog.confirmed.connect (_delete_dialog_confirmed)
		
	# show dialog
	add_child(dialog)
	dialog.popup_centered() # center on screen
	dialog.show()


func _delete_dialog_canceled() -> void:
	profile_to_delete = -1

func _delete_dialog_confirmed() -> void:
	# Profil löschen und Szene neu aufrufen
	if DB.delete_profile(profile_to_delete):
		UiController.goto_ui_scene(UiController.PLAYER_PROFILE)


func _on_details_pressed() -> void:
	# TODO
	# "normale Inventare" anzeigen: MusikMon und Items
	pass

func _on_del_pressed() -> void:
	var profile_id:int = get_meta("profile_id")
	delete_player_profile(profile_id)
		
	
func _on_active_pressed() -> void:
	if !profile_active:
		# Profil aktivieren und Szene neu aufrufen
		var profile_id:int = get_meta("profile_id")
		if DB.activate_profile(profile_id):
			RuntimeParameter.player_id = profile_id
			UiController.goto_ui_scene(UiController.PLAYER_PROFILE)
	

func _on_nickname_text_submitted(new_text: String) -> void:
	var valid_nickname = PlayerService.is_valid_nickname(new_text)
	if DB.set_player_nickname(player_id, valid_nickname):
		print("✅ Nickname erfolgreich geändert")
	else:
		printerr("❌ Nickname NICHT gespeichert")


func _on_edit_starter_mon_pressed() -> void:
	var profile_id:int = get_meta("profile_id")
	RuntimeParameter.player_id = profile_id
	UiController.goto_ui_scene(UiController.MUSIKMON_PEDIA)
