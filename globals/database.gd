#database.gd
extends Node

var db : SQLite
var db_open : bool = false
var query: String
const DB_FILE := "res://database/musikmon.db"

func _ready() -> void:
	open_db()

func open_db() -> SQLite:
	db = SQLite.new()
	db.path = DB_FILE
	var suc = db.open_db()
	if !suc:
		push_error("Fehler beim Öffnen der Datenbank: ", suc)
	db_open = true
	return db
	
func close_db() -> void:
	db.close_db()
	
func load_mon_details(mon_id:int) -> Dictionary:
	query = "
	SELECT
	m.name, m.fusion, m.beschreibung, m.img_256,
	t1.name AS typ1_name, t1.icon AS typ1_icon, t1.symbol AS typ1_symbol,
	t2.name AS typ2_name, t2.icon AS typ2_icon, t2.symbol AS typ2_symbol
	FROM
	musikmon AS m
	JOIN
	typen AS t1 ON m.typ1_id = t1.id
	LEFT JOIN
	typen AS t2 ON m.typ2_id = t2.id
	WHERE m.id = %d;" % mon_id

	db.query(query)
	var res = db.query_result
	return res[0]

func load_mon_inventory(player_id:int, starter_inv:bool=false) -> Array:
	query = "SELECT id, mon_id, mon_nickname FROM spieler_inventar_mon WHERE spieler_id = ? AND starter_mon = ? ORDER BY id ASC;"
	db.query_with_bindings(query, [player_id, starter_inv])
	var error = db.error_message
	if error == "not an error":
		# AllGood
		return [true, db.query_result]
	else:
		# Error
		return[false, error]
	
func set_mon_nickname(inv_id:int, nickname:String) -> Array:
	query = "UPDATE spieler_inventar_mon SET mon_nickname = ? WHERE id = ?"
	db.query_with_bindings(query, [nickname, inv_id])
	var error = db.error_message
	if error == "not an error":
		# AllGood
		return [true, ""]
	else:
		# Error
		return[false, error]
	
func save_mon_inventory(player_id:int, mon_id:int, nickname:String="", starter_mon:bool=false) -> int:
	# TODO
	# Error handling/return
	var trimmed_nickname = nickname.strip_edges()
	query = "INSERT INTO spieler_inventar_mon (id, spieler_id, mon_id, starter_mon, mon_nickname) VALUES (NULL,?,?,?,?)"
	db.query_with_bindings(query, [player_id, mon_id, starter_mon, trimmed_nickname])
	var error = db.error_message
	if error == "not an error":
		# AllGood
		return db.last_insert_rowid
	else:
		# Error
		printerr(error)
		return -1
	
func delete_mon_inventory(inv_id:int):
	# TODO
	# Error handling/return
	query = "DELETE FROM spieler_inventar_mon WHERE id = ?"
	db.query_with_bindings(query, [inv_id])
	var error = db.error_message
	if error == "not an error":
		# AllGood
		pass
	else:
		# Error
		printerr("database.gd => delete_mon_inventory(inv_id:int)")
		printerr(error)
	
func load_mon_list() -> Array:
	query = "SELECT id, name, img_96 FROM musikmon ORDER BY name ASC;"
	db.query(query)
	return db.query_result
	
func new_player_profile(nickname:String) -> int:
	# Update spieler.last_active
	query = "UPDATE spieler SET last_active = 0"
	db.query(query)
	
	query = "INSERT INTO spieler (id, nickname, last_active) VALUES (NULL,?,1)"
	db.query_with_bindings(query, [nickname])
	var error = db.error_message
	if error != "not an error":
		print(error)
		return -1
	else:
		var player_id = db.last_insert_rowid
		return player_id
		
func load_player_profile(player_id:int=-1) -> int:	
	if player_id <= 0:
		# No Player ID specified, load last active profile
		query = "SELECT id FROM spieler WHERE last_active = 1;"
		db.query(query)
		var res = db.query_result
		
		if res.size() < 1:
			# Fresh DB, no player profile present => Create new profile!
			return -1
		else:
			player_id = res[0]['id']
	else:
		# Load specified profile
		query = "SELECT id FROM spieler WHERE id = '%d';" % player_id
		db.query(query)
		var res = db.query_result
		player_id = res[0]
	return player_id

func load_player_profiles() -> Array:
	query = "SELECT * FROM spieler ORDER BY last_active DESC"
	db.query(query)
	
	var error = db.error_message
	if error != "not an error":
		return [false, error]
	else:
		var res = db.query_result
		return [true, res]
		
func activate_profile(profile_id:int) -> bool:	
	# All profiles last_active = 0
	query = "UPDATE spieler SET last_active = 0"
	db.query(query)
	
	# Actiate selected profile
	query = "UPDATE spieler SET last_active = 1 WHERE id = ?"
	db.query_with_bindings(query, [profile_id])
	var error = db.error_message
	if error != "not an error":
		return false
	else:
		return true
		
func delete_profile(profile_id:int) -> bool:
	# ALLES von spieler.id = profile_id LÖSCHEN
	db.query_with_bindings("BEGIN TRANSACTION", [])
	var success1 = db.query_with_bindings("DELETE FROM spieler_inventar_items WHERE spieler_id = ?", [profile_id])
	var success2 = db.query_with_bindings("DELETE FROM spieler_inventar_mon WHERE spieler_id = ?", [profile_id])
	var success3 = db.query_with_bindings("DELETE FROM spieler WHERE id = ?", [profile_id])
	
	if success1 and success2 and success3:
		db.query_with_bindings("COMMIT", [])
		return true
	else:
		db.query_with_bindings("ROLLBACK", [])
		printerr("Error deleting profile - rolled back!")
		return false
		
func set_player_nickname(player_id:int, nickname:String) -> bool:
	query = "UPDATE spieler SET nickname = ? WHERE id = ?"
	db.query_with_bindings(query, [nickname, player_id])
	var error = db.error_message
	if error == "not an error":
		# AllGood
		return true
	else:
		# Error
		return false
		
func get_player_nickname(player_id:int) -> String:
	query = "SELECT nickname FROM spieler WHERE id = ?"
	db.query_with_bindings(query, [player_id])
	var error = db.error_message
	if error == "not an error":
		# AllGood
		var res = db.query_result
		return res[0]['nickname']
	else:
		# Error
		printerr(error)
		return ""
