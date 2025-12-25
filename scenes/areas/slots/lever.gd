extends Area2D

signal pulled

@export var max_pull_distance: float = 100.0
@export var activation_threshold: float = 1.0
@export var scale_speed: float = 0.001
@export var shaft: Sprite2D

var dragging = false
var start_pos: Vector2
var start_scale: Vector2
var is_triggered = false

func _ready():
	start_pos = position
	start_scale = scale

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			dragging = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true

func _process(_delta):
	if dragging:
		#old y vs new y
		var mouse_pos = get_global_mouse_position()
		var local_mouse_y = get_parent().to_local(mouse_pos).y
		var new_y = clamp(local_mouse_y, start_pos.y, start_pos.y + max_pull_distance)
		position.y = new_y
		var current_pull = position.y - start_pos.y
		#scale these
		var extra_scale = current_pull * scale_speed
		scale = start_scale + Vector2(extra_scale, extra_scale) #hacky
		shaft.material.set_shader_parameter("up", extra_scale)
		
		check_activation()
	else:
		# bob back up
		position.y = lerp(position.y, start_pos.y, 0.2)
		scale = lerp(scale, start_scale, 0.2)
		shaft.material.set_shader_parameter("up", lerp(scale, start_scale, 0)) #hacky
		is_triggered = false

func check_activation():
	var pull_percent = (position.y - start_pos.y) / max_pull_distance
	
	if pull_percent >= activation_threshold and not is_triggered:
		is_triggered = true
		pulled.emit()
