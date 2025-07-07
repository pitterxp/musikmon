extends Control

@onready var btn :Button = $"."
var player_id : int = RuntimeParameter.player_id


func _ready() -> void:
	if player_id > 0:
		var res:Array = DB.load_player_tag(player_id)
		
		if res[0] == true:
			var player_data = res[1]
			var nickname:String = player_data['nickname']
			var description:String = player_data['beschreibung']
			var ico:String = PlayerService.img_path(description, 64)
			btn.icon = load(ico)
			btn.text = nickname

func _on_pressed() -> void:
	# TODO
	# Fancy Menu-Stuff
	UiController.goto_ui_scene(UiController.PLAYER_PROFILE)
