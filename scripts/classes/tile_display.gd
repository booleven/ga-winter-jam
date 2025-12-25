class_name TileDisplay extends Node2D

var sprite: Sprite2D
var time: int = 0

var outline_shader: Shader = preload("res://assets/shaders/outline.gdshader")
var score_material: ShaderMaterial

func _init() -> void:
	sprite = Sprite2D.new()
	add_child(sprite)
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
