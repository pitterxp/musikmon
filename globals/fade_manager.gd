extends CanvasLayer

@onready var fade_rect := $FadeRect

func _ready() -> void:
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_rect.color.a = 0.0  # Start: transparent
	self.layer = 999  # immer ganz oben

func fade_to_black(duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, duration)
	await tween.finished

func fade_to_clear(duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, duration)
	await tween.finished
