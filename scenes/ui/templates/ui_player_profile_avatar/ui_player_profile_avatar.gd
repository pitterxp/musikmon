extends Node

var player_id : int = RuntimeParameter.player_id
@onready var avatar_list: ItemList = $"."

signal avatar_selected()

func _ready() -> void:
	# here we always need a player_id
	if player_id < 0:
		player_id = PlayerService.check_playerid()
	
	list_avatars()
		
func list_avatars() -> void:
	var res: Array = DB.load_avatar_list()
	
	if res[0] == true:
		var data: Array = res[1]
		var idx: int = 0
		for row in data:
			var id:int = row['id']
			var description: String = row['beschreibung']
			var ico:String = PlayerService.img_path(description, 128)
			var icon_texture: Texture2D = load(ico)
			
			avatar_list.add_item("", icon_texture)
			var metadata_dict = {
				"id": id,
				"name": description
			}
			avatar_list.set_item_metadata(idx, metadata_dict)
			idx += 1

func save_player_avatar(avatar_id:int) -> void:
	print("Saving Avatar ID ",avatar_id," to Player Profile #", player_id)
	var res:Array = DB.save_player_avatar(player_id, avatar_id)
	if res[0] == true:
		print("Avatar selection saved to DB")
		avatar_selected.emit()

func _on_item_activated(index: int) -> void:
	var avatar_data = avatar_list.get_item_metadata(index)
	save_player_avatar(avatar_data['id'])
