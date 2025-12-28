class_name TileDisplayTooltip extends VBoxContainer

func _init(tile: TileEntity) -> void:
	if not tile:
		return
	
	#spacing
	add_theme_constant_override("separation", 4)
	
	#name
	_add_info_box(tile.name)
	
	#pfx
	for effect in tile.pfx:
		_add_info_box(effect.description)
	
	#afx
	for effect in tile.afx:
		_add_info_box(effect.description)

func _add_info_box(text: String) -> void:
	var panel = PanelContainer.new()
	
	#box
	var box = StyleBoxFlat.new()
	box.bg_color = Color(0.15, 0.15, 0.15, 0.95)
	box.border_color = Color(0.4, 0.4, 0.4, 1.0)
	box.border_width_left = 3
	box.border_width_right = 3
	box.border_width_top = 3
	box.border_width_bottom = 3
	box.corner_radius_top_left = 8
	box.corner_radius_top_right = 8
	box.corner_radius_bottom_left = 8
	box.corner_radius_bottom_right = 8
	box.content_margin_left = 12
	box.content_margin_right = 12
	box.content_margin_top = 10
	box.content_margin_bottom = 10
	
	panel.add_theme_stylebox_override("panel", box)
	
	#label
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	label.add_theme_font_size_override("font_size", 18)
	
	#babies
	panel.add_child(label)
	add_child(panel)
