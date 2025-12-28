class_name TooltipTrigger extends Area2D

var tile_entity: TileEntity
var tooltip: TileDisplayTooltip = null

func _init(size: Vector2, tile: TileEntity) -> void:
	tile_entity = tile
	
	#shape needed for area2d
	var collision = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = size
	collision.shape = rect_shape
	add_child(collision)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	#make tooltip
	tooltip = TileDisplayTooltip.new(tile_entity)
	add_child(tooltip)
	
	#move up
	tooltip.position = Vector2(-tooltip.size.x / 2, -80)

func _on_mouse_exited() -> void:
	tooltip.queue_free()
