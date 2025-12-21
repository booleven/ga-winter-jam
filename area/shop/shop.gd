extends Node2D

var outline_shader: Shader = preload("res://resources/shaders/outline.gdshader")
var outline_material: ShaderMaterial

var reroll_cost: int = 150

@export var potential_tiles: Array[Tile] = []
var current_tiles: Array[Tile] = []

func _init() -> void:
	outline_material = ShaderMaterial.new()
	outline_material.shader = outline_shader
	outline_material.set_shader_parameter("width", 10.0)

func _ready() -> void:
	reroll()

func _process(delta: float) -> void:
	pass

func _on_zipper_pressed() -> void:
	if global.money >= reroll_cost:
		global.money -= reroll_cost
		reroll_cost += 100
		print("money: ", global.money)
		reroll()
	else:
		print("need at least ", reroll_cost)

func reroll():
	for child in get_children():
		if child is TileDisplay:
			child.queue_free()
	current_tiles.clear()
	
	#5 tiles in shop!
	for i in range(5):
		var random_tile = potential_tiles.pick_random() as Tile
		current_tiles.append(random_tile)
		
		var s = TileDisplay.new()
		
		s.name = str(i)
		s.sprite.texture = random_tile.texture
		s.position = Vector2(i * 60 - 650, i * -90.0 + 200)
		s.rotation = deg_to_rad(randf_range(-45.0, 45.0))
		
		add_child(s)

func new_load():
	return

func _on_zipper_mouse_entered() -> void:
	var zipper = get_node("Zipper") as TextureButton
	zipper.material = outline_material

func _on_zipper_mouse_exited() -> void:
	var zipper = get_node("Zipper") as TextureButton
	zipper.material = null

func _on_wrench_pressed() -> void:
	pass 

func _on_wrench_mouse_entered() -> void:
	var wrench = get_node("Wrench") as TextureButton
	wrench.material = outline_material

func _on_wrench_mouse_exited() -> void:
	var wrench = get_node("Wrench") as TextureButton
	wrench.material = null
