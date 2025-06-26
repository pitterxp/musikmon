extends Node

@onready var bgm = AudioStreamPlayer.new()
@onready var sfx = AudioStreamPlayer.new()
var library: AudioLibrary = preload("res://assets/audio_library.tres")


const BGM_BUS_NAME = "bgm"
const SFX_BUS_NAME = "sfx"

var bgm_autoplay: bool = true
var bgm_loop: bool = false

var default_ui_click_sound := "mouse-click2"
var default_bgm := ""

func _ready() -> void:
	# Initializing audio like a champ, nummer1 *o7* <3
	bgm.bus = BGM_BUS_NAME
	sfx.bus = SFX_BUS_NAME
	
	bgm.set_process_mode(Node.PROCESS_MODE_ALWAYS)
	sfx.set_process_mode(Node.PROCESS_MODE_ALWAYS)
	
	add_child(bgm)
	add_child(sfx)
	
	set_bgm_volume(GameParameter.bgmVolume)
	set_sfx_volume(GameParameter.sfxVolume)
	
	# BGM Autoplay?
	if bgm_autoplay:
		_play_default_bgm()

func _play_default_bgm() -> void:
	if default_bgm != "":
		# Set Looping
		bgm.set("parameters/looping", bgm_loop)
		# Play default bg music
		play_bgm(default_bgm)

func play_sfx(sfx_name: String, prevent_overlap := false) -> void:
	if prevent_overlap and sfx.playing:
		return
		
	if !library.sfx.has(sfx_name):
		push_warning("SFX '%s' nicht gefunden." % sfx_name)
		return

	sfx.stream = library.sfx[sfx_name]
	sfx.play()



func play_bgm(bgm_name: String) -> void:
	if !library.music.has(bgm_name):
		push_warning("🚨BGM '%s' nicht in der Bibliothek gefunden." % bgm_name)
		return
		
	bgm.stream = library.music[bgm_name]
	bgm.play()
	
func stop_bgm() -> void:
	if bgm.playing:
		bgm.stop()
		return
		
func is_bgm_playing() -> bool:
	return bgm.playing

func is_sfx_playing() -> bool:
	return sfx.playing


func set_bgm_volume(new_volume:float) -> void:
	new_volume = clamp(new_volume, 0.0, 1.0)
	var db_value = linear_to_db(new_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BGM_BUS_NAME), db_value)
	
func set_sfx_volume(new_volume:float) -> void:
	new_volume = clamp(new_volume, 0.0, 1.0)
	var db_value = linear_to_db(new_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SFX_BUS_NAME), db_value)

func play_ui_button_sound(variation = 0):
	if variation <= 0:
		play_sfx(default_ui_click_sound)
