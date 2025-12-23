@tool
class_name ColorShape extends Control

enum ShapeType { RECTANGLE, CIRCLE, CAPSULE }

@export var shape: ShapeType = ShapeType.RECTANGLE:
	set(value):
		shape = value
		queue_redraw()

@export var color: Color = Color.WHITE:
	set(value):
		color = value
		queue_redraw()

func _draw() -> void:
	var rect = Rect2(Vector2.ZERO, size)
	
	match shape:
		ShapeType.RECTANGLE:
			draw_rect(rect, color)
			
		ShapeType.CIRCLE:
			_draw_smooth_shape(rect, color, 1024)
			
		ShapeType.CAPSULE:
			_draw_smooth_shape(rect, color, min(size.x, size.y) / 2.0)

func _draw_smooth_shape(rect: Rect2, draw_color: Color, radius: float) -> void:
	var sb = StyleBoxFlat.new()
	sb.bg_color = draw_color
	sb.set_corner_radius_all(radius)
	sb.anti_aliasing = true
	draw_style_box(sb, rect)

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
