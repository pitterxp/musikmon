extends AcceptDialog

@onready var nickname_input = $VBoxContainer/nickname
@onready var save_button = $VBoxContainer/save

var db: SQLite
var valid_nickname: bool = false

func _ready() -> void:
	# Btn Focus + Audio
	UiController.setup_ui_buttons_in_scene()

	

func _save_profile() -> void:
	var nickname = $VBoxContainer/nickname.text
	var ret = PlayerService.is_valid_nickname(nickname)
	if ret[0]:
		var player_id = DB.new_player_profile(ret[1])
		
		if player_id <= 0:
			$VBoxContainer/nickname.modulate = Color.RED
		else:
			#PlayerService.save_profile(player_id)
			$VBoxContainer/nickname.modulate = Color.WHITE
			$VBoxContainer/save.text = "✅💾 Proifl ID# %d" %player_id
			$VBoxContainer/nickname.editable = false
			$VBoxContainer/save.disabled = true
			queue_free()

	
func _on_save_pressed() -> void:
	if !valid_nickname:
		$VBoxContainer/nickname.modulate = Color.RED
		return
	_save_profile()

func _on_nickname_text_changed(nickname: String) -> void:
	if nickname.length() < 3:
		$VBoxContainer/nickname.modulate = Color.RED
		valid_nickname = false
	else:
		var ret = PlayerService.is_valid_nickname(nickname)
		if ret[0]:
			$VBoxContainer/nickname.modulate = Color.WHITE
			valid_nickname = true

func _on_nickname_text_submitted(_new_text: String) -> void:
	if !valid_nickname:
		$VBoxContainer/nickname.modulate = Color.RED
		return
	_save_profile()
