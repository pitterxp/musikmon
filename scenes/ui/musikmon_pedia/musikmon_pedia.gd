extends Node

var db : SQLite
var current_mon_id : int = 1
var mon_count : int

var player_id : int = RuntimeParameter.player_id
var startermon_count = 0
var startermon_max = 3
var placeholder_thumbnail = "res://scenes/musikmon/mon_placeholder/mon-placeholder_96.png"
var mon_list : Array

const INV_TEMPLATE = "res://scenes/ui/templates/ui_mon_inventory/ui_mon_inventory.tscn"



func _ready() -> void:
	
	# Btn Click Sound + Focus
	UiController.setup_ui_buttons_in_scene()

	# Load MusikMon List
	_fetch_mon_list()
	
	# Load one MusikMon to display
	if current_mon_id > 0:
		_display_mon(current_mon_id)
	
	# Check for userprofile & inventory
	if player_id > 0:
		var player_tag = preload("res://scenes/ui/templates/ui_player_profil_tag/ui_player_profil_tag.tscn").instantiate()
		add_child(player_tag)
		_fetch_mon_inventory()


func _display_mon(mon_id:int) -> void:
	# Fetch DB Data
	var mon_data = 	DB.load_mon_details(mon_id)
	var mon_name = mon_data['name']
	var mon_fusion = mon_data['fusion']
	var mon_beschreibung = mon_data['beschreibung']
	var mon_img = mon_data['img_256']
	#TODO: "typ1_icon": "res://icons/laerm.png"
	var typ1 = mon_data['typ1_symbol'] + " " +  mon_data['typ1_name']
	var typ2 = mon_data['typ2_symbol'] + " " +  mon_data['typ2_name']
	
	# Apply DB data
	$Content/MusikmonView/mon_name.text = mon_name
	var texture_rect_node = $Content/MusikmonView/mon_img
	var loaded_texture = load(mon_img)
	texture_rect_node.texture = loaded_texture
	$Content/MusikmonView/mon_fusion.text = "Fusion:\n" + mon_fusion
	$Content/MusikmonView/mon_typ.text = "Typen:\n" + typ1 + " + " + typ2
	$Content/MusikmonView/mon_description.text = mon_beschreibung
	
func _fetch_mon_list() -> void:
	# Fetch DB Data
	mon_list = DB.load_mon_list()
	
	# Set "max" MusikMon count for "Display Details Navigation"
	mon_count = mon_list.size()
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("prev_musikmon"):
		_prev_mon()

	if Input.is_action_just_pressed("next_musikmon"):
		_next_mon()

	if Input.is_action_just_pressed("select_musikmon"):
		_select_mon(current_mon_id)


func _set_inventory_gui(mon_id:int, mon_nickname:String="", inv_id:int=0) -> void:
	var mon_name: String
	var mon_thumbnail: String
	
	for key in mon_list:
		if key['id'] == mon_id:
			mon_name = key['name']
			mon_thumbnail = key['img_96']
			
	# Template laden
	var template = preload(INV_TEMPLATE).instantiate()
	
	# Signal verbinden (BEVOR du es zur Scene hinzufügst)
	template.mon_deleted.connect(_on_mon_deleted)
	
	# Template zur GUI hinzufügen
	$Content/InventoryView.add_child(template)
	
	# Daten übergeben
	if mon_nickname != "":
		mon_name = mon_nickname
	template.setup_musikmon(mon_id, mon_name, mon_thumbnail, true, inv_id)
	
	# Startermon mitzählen
	startermon_count += 1
	
func _on_mon_deleted():
	startermon_count -= 1
	
func _select_mon(mon_id):
	# Here we NEED! a valid player_id
	player_id = PlayerService.check_playerid()
	
	# Max starter musikmon?
	if startermon_count >= startermon_max:
		printerr("just THREE musikmon for start")
		return

	_set_inventory_gui(mon_id)

func _fetch_mon_inventory() -> void:
	var mon_inv_data:Array = DB.load_mon_inventory(player_id, true)
	var mon_inv = mon_inv_data[1]
	if mon_inv.size() >= 1:
		for key in mon_inv:
			var db_inv_id:int = key['id']
			var inv_mon_id:int = key['mon_id']
			var inv_mon_nickname:String = key['mon_nickname']
			_set_inventory_gui(inv_mon_id, inv_mon_nickname, db_inv_id)
			current_mon_id += 1

func _prev_mon() -> void:
	current_mon_id -= 1
	if current_mon_id <= 0:
		current_mon_id = mon_count
	_display_mon(current_mon_id)
	
func _next_mon() -> void:
	current_mon_id += 1
	if current_mon_id > mon_count:
		current_mon_id = 1
	_display_mon(current_mon_id)
	
#################################################################### 
# MusikMon DetailView Navigation
#################################################################### 
func _on_prev_mon_pressed() -> void:
	_prev_mon()

func _on_select_mon_pressed() -> void:
	_select_mon(current_mon_id)

func _on_next_mon_pressed() -> void:
	_next_mon()
	
#################################################################### 
# Main UI Scene Navigation
#################################################################### 
func _on_main_menu_pressed() -> void:
	UiController.goto_ui_scene(UiController.MAIN_MENU)

func _on_play_pressed() -> void:
	UiController.goto_ui_scene(UiController.PRE_ADVENTURE)
