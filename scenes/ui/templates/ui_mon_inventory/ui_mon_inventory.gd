extends Control

@onready var inv_slot:= $"."
@onready var img:= $MonImgNickname/img
@onready var nickname:= $MonImgNickname/nickname
@onready var del_btn:= $del

var player_id:int = RuntimeParameter.player_id
var placeholder_mon_thumbnail:= "res://scenes/musikmon/mon_placeholder/mon-placeholder_96.png"
var placeholder_mon_name:= "Musikmon"

signal mon_deleted(db_inv_id: int)


# SIGNAL FUNC
func setup_musikmon(mon_id:int, mon_name:String, mon_thumbnail:String, mon_starter:bool=false, inv_id:int=0) -> void:
	
	# 1. Save to DB, if this is a NEW musikmon
	var db_inv_id:int
	if inv_id == 0:
		db_inv_id = DB.save_mon_inventory(player_id, mon_id, "", mon_starter)
	else:
		db_inv_id = inv_id
	
	# 2. Add meta data
	set_meta("db_inv_id", db_inv_id)
	
	# 3. Update GUI
	img.texture = load(mon_thumbnail)
	nickname.placeholder_text = "Benenne dein " + mon_name
	nickname.tooltip_text = "Benenne dein " + mon_name

func save_nickname(db_inv_id:int, new_nickname:String) -> void:
	# Validate entered musikmon nickname
	var valid_nickname = PlayerService.is_valid_nickname(new_nickname)
	if valid_nickname[0]:
		var ret = DB.set_mon_nickname(db_inv_id, new_nickname)
		if !ret[0]:
			$MonImgNickname/nickname.modulate = Color.RED
			printerr(ret[1])
		else:
			$MonImgNickname/nickname.modulate = Color.WHITE
	else:
		$MonImgNickname/nickname.modulate = Color.RED
		printerr(valid_nickname[1])

func _on_del_pressed() -> void:
	var db_inv_id:int = get_meta("db_inv_id")
	DB.delete_mon_inventory(db_inv_id)
	# Signal senden
	mon_deleted.emit()
	# Template aus GUI entfernen
	queue_free()


func _on_nickname_text_submitted(new_text: String) -> void:
	var db_inv_id:int = get_meta("db_inv_id")
	save_nickname(db_inv_id, new_text)
