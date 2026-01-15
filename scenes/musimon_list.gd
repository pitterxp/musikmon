extends VBoxContainer

# Lists all MusikMon entries from the database and emits the selected ID.
# Requires the godot-sqlite addon.

signal mon_selected(mon_id: int)

var db : SQLite

@onready var mon_list : ItemList = $mon_list

func _ready() -> void:
    db = SQLite.new()
    db.path = "res://database/musimon.db"
    var err := db.open_db()
    if err != OK:
        push_error("Failed to open musimon.db")
        return
    _populate_list()

func _populate_list() -> void:
    var rows = db.query("SELECT id, name FROM musikmon ORDER BY id;")
    if rows:
        for row in rows:
            var idx := mon_list.item_count
            mon_list.add_item(row.get("name", ""))
            mon_list.set_item_metadata(idx, row.get("id", 0))

func _on_mon_list_item_activated(index: int) -> void:
    var mon_id : int = mon_list.get_item_metadata(index)
    emit_signal("mon_selected", mon_id)
