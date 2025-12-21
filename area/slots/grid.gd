extends Node2D

@export var spacing: Vector2 = Vector2(250, 250)
@export var sprite_texture: Texture2D
@export var scaling: float = 1.0
var tiles: Array[TileDisplay] = []

@export var wrap_materials: Array[ShaderMaterial] = []

func _ready() -> void:
	create_grid()
	tiles[0].material = wrap_materials[0]

# |0 3 6|
# |1 4 7|
# |2 5 8|
func create_grid():
	var index = 0
	#tiles.clear()
	
	for x in range(3): #col
		for y in range(3): #row
			var s = TileDisplay.new()
			
			s.name = str(index)
			s.sprite.texture = sprite_texture
			s.position = Vector2(x * spacing.x, y * spacing.y)
			s.scale.x = scaling
			s.scale.y = scaling
			
			add_child(s)
			
			tiles.append(s)
			
			index += 1
