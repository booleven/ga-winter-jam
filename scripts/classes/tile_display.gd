class_name TileDisplay extends Node2D

var sprite: Sprite2D
var tile_entity: TileEntity
var tooltip_trigger: TooltipTrigger
var outline_shader: Shader = preload("res://assets/shaders/outline.gdshader")
var score_material: ShaderMaterial

func _init(tile: TileEntity) -> void:
	tile_entity = tile
	
	#sprite stuff
	sprite = Sprite2D.new()
	sprite.texture = tile_entity.texture
	add_child(sprite)
	
	#tooltip triggering stuff
	var texture_size = tile_entity.texture.get_size()
	tooltip_trigger = TooltipTrigger.new(texture_size, tile_entity)
	add_child(tooltip_trigger)
	
	#temporary i guess
	score_material = ShaderMaterial.new()
	score_material.shader = outline_shader
	score_material.set_shader_parameter("width", 10.0)

func animate(state: String) -> void:
	match state:
		"idle":
			print("idle")
		"score":
			sprite.material = score_material
			await get_tree().create_timer(0.5).timeout #hardcoded
			sprite.material = null
		"freeze":
			print("freeze")
		_:
			push_warning(state + "invalid")
