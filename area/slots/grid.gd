extends Node2D

@export var spacing: Vector2 = Vector2(250, 250)
@export var sprite_texture: Texture2D
@export var scaling: float

func _ready() -> void:
	create_grid()

func create_grid():
	var index = 0
	
	for y in range(3): #row
		for x in range(3): #col
			var s = Sprite2D.new()
			
			s.name = str(index)
			s.texture = sprite_texture
			s.position = Vector2(x * spacing.x, y * spacing.y)
			s.scale.x = scaling
			s.scale.y = scaling
			
			add_child(s)
			
			index += 1
