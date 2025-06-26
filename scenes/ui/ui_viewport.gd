extends Control

func _ready():
	get_viewport().size_changed.connect(_on_viewport_changed)
	_update_layout()

func _on_viewport_changed():
	_update_layout()
	
func _update_layout():
	
	# VERTICAL
	var viewport_height = get_viewport().size.y
	# Header = 15%, Content = 70%, Footer = 15%
	$Header.custom_minimum_size.y = viewport_height * 0.15
	$Footer.custom_minimum_size.y = viewport_height * 0.15
	
	# HORIZONTAL
	var viewport_width = get_viewport().size.x
	# MusikmonView = 75%, InventoryView = 25%
	$Content/MusikmonView.custom_minimum_size.x = viewport_width * 0.5
	$Content/InventoryView.custom_minimum_size.x = viewport_width * 0.5
	print("ViewPort Size x: ",viewport_width, " | y: ",viewport_height)
	print("Mon-View & Inv-View x: ", viewport_width * 0.5)
