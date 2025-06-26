extends Node

# Lists all MusikMon entries from the database and emits the selected ID.
# Requires the godot-sqlite addon.

signal mon_selected(mon_id: int)
var db : SQLite
@onready var mon_list : ItemList = $mon_list
@onready var mon_inventory : ItemList = $InventoryContainer/inventory

var mon_list_tooltip : String = "🔎 LMB\n➕ RMB"
var mon_inventory_tooltip : String = "🔎 LMB\n➖ RMB"

var mon_inventory_list = {} 
var mon_inventory_count : int = 0
var mon_inventory_count_max : int = 3

func _ready() -> void:
	UiController.setup_ui_buttons_in_scene()
	
	db = SQLite.new()
	db.path = "res://database/musikmon.db"
	db.open_db()
	
	# Listening to Detail View: add musikmon to inventory
	var sender = get_node("MusikMonDetailView/")
	sender.add_mon.connect(_add_mon)
	
	_populate_list()
	
func _add_mon(mon_id:int) -> void:
	#print ("signal empfangen: ",mon_id)	
	_handle_inventory(mon_id-1) #Mask: idx = mon_id - 1

func _populate_list() -> void:
	db.query("SELECT id, name, img_96 FROM musikmon ORDER BY id ASC;")

	for row in db.query_result:
		#print(row)
		#{ "id": 18, "name": "Tonkzunge", "img_96": "res://scenes/musikmon/Tonkzunge/img/Tonkzunge_96.png" }
		#var idx := mon_list.item_count
		var id = row.get("id", 0)
		var mon_name : String = row.get("name", "")
		mon_name += " ("+str(id)+")"
		var mon_icon : String = row.get("img_96", "")
		var icon_texture: Texture2D = load(mon_icon)
		var idx : int = id - 1
		mon_list.add_item(mon_name, icon_texture)
		var metadata_dict = {
			"id": id,
			"name": mon_name
		}
		mon_list.set_item_metadata(idx, metadata_dict)
		mon_list.set_item_tooltip(idx, mon_list_tooltip)

func _handle_inventory(index: int, mode = "add") -> void:
	#print("inventory ..." + mode)
	var mon = mon_list.get_item_metadata(index)
	var mon_id = mon["id"]
	var mon_name = mon["name"]
	var mon_icon = mon_list.get_item_icon(index)
	
	# Add MusikMon to mon_inventory
	if mode == "add":
		#print(" ... adding")
		# Zu viele Musikmon?
		if mon_inventory_count < mon_inventory_count_max:
			# Identische Musikmon?
			#TODO mon_inventory_list raus, mon_inventory rein
			if not mon_inventory_list.has(mon_id):
				# Inventory für RuntimeData speichern
				mon_inventory_list[mon_id] = {"name": mon_name, "id": mon_id}
				save_inventory_runtimedata()
				
				mon_inventory.add_item(mon_name, mon_icon)
				var metadata_dict = {
					"id": mon_id,
					"name": mon_name
				}
				mon_inventory.set_item_metadata(mon_inventory_count, metadata_dict)
				mon_inventory.set_item_tooltip(mon_inventory_count, mon_inventory_tooltip)
				mon_inventory_count += 1
			else:
				print("Doublette")
		else:
			# Quick & Dirty Variante
			var dialog = AcceptDialog.new()
			dialog.dialog_text = "TOO MANY"
			add_child(dialog)
			dialog.popup_centered()
			print("TOO MANY")
			
	if mode == "remove" && mon_inventory_count >=0:
		#print("... removing!")
		#var mon_inv = mon_inventory.get_item_metadata(index)
		#var mon_inv_id = mon_inv["id"]
		#var mon_inv_name = mon_inv["name"]
		#print("removing mon '"+mon_inv_name+"' (",mon_inv_id,") from inv!")
		
		# Inventory für RuntimeData editieren
		mon_inventory_list.erase(index)
		save_inventory_runtimedata()
		
		mon_inventory.remove_item(index)
		mon_inventory_count -= 1

func save_inventory_runtimedata() -> void:
	print("💾 Speichere MusikMon Inventar (RT-Data)")
	RuntimeParameter.player_inventory_musikmon = mon_inventory_list
	print("Lade MusikMon Inventar (RT-Data)")
	print(RuntimeParameter.player_inventory_musikmon)

func _on_mon_list_item_clicked(index: int, _at_position: Vector2, mouse_button_index: int) -> void:
	var mon = mon_list.get_item_metadata(index)
	if mouse_button_index == 1:
		mon_selected.emit(mon["id"])
	if mouse_button_index == 2:
		_handle_inventory(index)


func _on_inventory_item_clicked(index: int, _at_position: Vector2, mouse_button_index: int) -> void:
	#print("mon_inventory clicked. Index: ", index , " | at_pos: ", at_position, " | MB: ", mouse_button_index)
	var mon = mon_inventory.get_item_metadata(index)
	if mouse_button_index == 1:
		mon_selected.emit(mon["id"])

	if mouse_button_index == 2:
		_handle_inventory(index, "remove")


func _on_mainmenu_pressed() -> void:
	UiController.goto_ui_scene(UiController.MAIN_MENU)
