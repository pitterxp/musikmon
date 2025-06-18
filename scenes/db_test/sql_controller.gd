extends Control

var db: SQLite
var table_created: bool = true

@onready var player_name: TextEdit = $CenterContainer/HBoxContainer/name
@onready var player_score: TextEdit = $CenterContainer/HBoxContainer2/score

func _ready() -> void:
	db = SQLite.new()
	db.path = "res://scenes/db_test/data.db"
	db.open_db()
	pass


func _on_create_table_button_down() -> void:
	if table_created:
		printerr("TABLE player already created!")
		return
	var table = {
		"id": {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name": {"data_type":"text"},
		"score": {"data_type":"int"}
	}
	db.create_table("player", table)
	pass # Replace with function body.


func _on_insert_data_button_down() -> void:
	if player_name.text == "":
		return
	var playername = player_name.text
	var playerscore = int(player_score.text)
	var data = {
		"name": playername,
		"score": playerscore
	}
	db.insert_row("player", data)


func _on_select_data_button_down() -> void:
	#db.select_rows("TABLE_NAME", "WHERE CLAUSE", "TABLE_FIELDS")
	#db.select_rows("player", "score > 10", ["*"] | ["name", "score"])
	var db_result = db.select_rows("player", "score > 100", ["*"])
	print(db_result)
	pass # Replace with function body.


func _on_update_data_button_down() -> void:
	var playername = player_name.text
	var playerscore = int(player_score.text)
	
	# TABLE_NAME, CONDITION, TABLE_FIELDS
	db.update_rows("player", "name = '"+playername+"'", {"score": playerscore, "name": "QWISI"})
	pass # Replace with function body.


func _on_delete_data_button_down() -> void:
	var playername = player_name.text
	if playername != "":
		db.delete_rows("player", "name = '"+playername+"'")
	pass # Replace with function body.


func _on_custom_select_button_down() -> void:
	pass # Replace with function body.
