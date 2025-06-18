extends Control

var bgm_volume: float = GameParameter.bgmVolume
var sfx_volume: float = GameParameter.sfxVolume
var init_slider = true

@onready var bgm_slider = $HBoxContainer/bgm/bgmVolume
@onready var sfx_slider = $HBoxContainer/sfx/sfxSlider

func _ready() -> void:	
	_init_slider()
	init_slider = false

func _init_slider() -> void:
	bgm_slider.value = bgm_volume
	sfx_slider.value = sfx_volume

func _set_bgm_slider(new_value:float) -> void:
	if !init_slider:
		GameParameter.bgmVolume = new_value
		AudioManager.set_bgm_volume(new_value)

func _set_sfx_slider(new_value:float) -> void:
	if !init_slider:
		GameParameter.sfxVolume = new_value
		AudioManager.set_sfx_volume(new_value)
		
		
func _on_bgm_volume_value_changed(value: float) -> void:
	_set_bgm_slider(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	_set_sfx_slider(value)
