extends VBoxContainer

# GDScript controlling the MusikMonDetailView scene.
# Uses the godot-sqlite addon to read data from musimon.db and populate the UI.

var db : SQLite
var current_mon_id : int = 1

@onready var name_label : Label = $name_label
@onready var img_texture : TextureRect = $img_texture
@onready var typ_label : Label = $typ_label
@onready var rollen_label : Label = $rollen_label
@onready var beschreibung_label : RichTextLabel = $beschreibung_label
@onready var zurueck_button : Button = $"../ButtonContainer/zurueck_button"
@onready var weiter_button : Button = $"../ButtonContainer/weiter_button"

signal add_mon(mon_id:int)

func _ready() -> void:
	db = SQLite.new()
	db.path = "res://database/musimon.db"
	db.open_db()
	
	#set_mon_id
	var sender = get_node("../")
	sender.mon_selected.connect(set_mon_id)
	
	if current_mon_id > 0:
		_load_mon(current_mon_id)

func _load_mon(mon_id:int) -> void:
	var sql := """
	SELECT mm.id, mm.name, mm.beschreibung, mm.img_256,
		   t1.name AS typ1_name,
		   t1.icon AS typ1_icon,
		   t1.beschreibung AS typ1_beschreibung,
		   t2.name AS typ2_name,
		   t2.icon AS typ2_icon,
		   t2.beschreibung AS typ2_beschreibung,
		   GROUP_CONCAT(r.name, ', ') AS rollenname,
		   GROUP_CONCAT(r.beschreibung, '\n') AS rollenbeschreibung
	FROM musikmon mm
	LEFT JOIN typen t1 ON mm.typ1_id = t1.id
	LEFT JOIN typen t2 ON mm.typ2_id = t2.id
	LEFT JOIN musikmon_rolle mr ON mm.id = mr.mon_id
	LEFT JOIN rollen r ON mr.rolle_id = r.id
	WHERE mm.id = %d;
	""" % mon_id
	
	db.query(sql)
	for i in db.query_result:
		var row : Dictionary = i
		var mm_description: String = row.get("beschreibung", "")
		var mon_name = row.get("name", "")
		#var mm_id = row.get("id", "")
		name_label.text = mon_name
		typ_label.text = row.get("typ1_name", "") + ("/" + row.get("typ2_name") if row.get("typ2_name", "") != "" else "")
		rollen_label.text = row.get("rollenname", "")
		beschreibung_label.text = mm_description
		var tex_path : String = row.get("img_256", "")
		if tex_path != "":
			var tex = load(tex_path)
			if tex:
				img_texture.texture = tex


func set_mon_id(mon_id:int) -> void:
	current_mon_id = mon_id
	if db:
		_load_mon(current_mon_id)

func _on_weiter_button_pressed() -> void:
	current_mon_id += 1
	if current_mon_id > 18:
		current_mon_id = 1
	_load_mon(current_mon_id)

func _on_zurueck_button_pressed() -> void:
	current_mon_id -= 1
	if current_mon_id < 1:
		current_mon_id = 18
	_load_mon(current_mon_id)

func _on_img_texture_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event: InputEventMouseButton = event
		if mouse_button_event.button_index == MOUSE_BUTTON_LEFT and mouse_button_event.pressed:
			#print("LMB")
			add_mon.emit(current_mon_id)
			get_viewport().set_input_as_handled()

func _on_ButtonContainer_zurueck_button_pressed() -> void:
	_on_zurueck_button_pressed()

func _on_ButtonContainer_weiter_button_pressed() -> void:
	_on_weiter_button_pressed()
