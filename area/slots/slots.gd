extends Node2D
class_name Slot

@export var total_tiles: Array[Tile] = []
@export var freeze_material: CanvasItemMaterial
var current_tiles: Array[Tile] = []
var points: int
const COLUMNS := [
	[0, 1, 2],
	[3, 4, 5],
	[6, 7, 8]
]
var frozen := [false, false, false]

func _ready():
	current_tiles.resize(9)
	update_visuals()

#spinning time export? do animation call, then logic
#await get_tree().create_timer(1.0).timeout
func new_spin():
	randomize()
	
	var extracted := []
	
	#extract tiles from unfrozen columns
	for col in range(3):
		if frozen[col]:
			continue
	
		for idx in COLUMNS[col]:
			var tile := current_tiles[idx]
			if tile != null:
				extracted.append(tile)
	
	#return extracted tiles to total
	total_tiles.append_array(extracted)
	total_tiles.shuffle()
	
	#refill only unfrozen columns
	for col in range(3):
		if frozen[col]:
			continue
		for idx in COLUMNS[col]:
			current_tiles[idx] = total_tiles.pop_front()
	
	update_visuals()
	
	await get_tree().create_timer(1).timeout
	
	var calculator := get_node("Calculator")
	calculator.stack(current_tiles)

func update_visuals():
	var grid := get_node("Grid")
	
	for i in range(9):
		var tile_display: TileDisplay = grid.tiles[i]
		var tile := current_tiles[i]
		
		if tile == null:
			tile_display.sprite.texture = null
		else:
			tile_display.sprite.texture = tile.texture

#downvote button
func _on_freeze_1_pressed():
	var b := get_node("FreezeButtons/Freeze1") as TextureButton
	if frozen[0] == false:
		b.material = freeze_material
	else:
		b.material = null
	frozen[0] = !frozen[0]

func _on_freeze_2_pressed() -> void:
	var b := get_node("FreezeButtons/Freeze2") as TextureButton
	if frozen[1] == false:
		b.material = freeze_material
	else:
		b.material = null
	frozen[1] = !frozen[1]

func _on_freeze_3_pressed() -> void:
	var b := get_node("FreezeButtons/Freeze3") as TextureButton
	if frozen[2] == false:
		b.material = freeze_material
	else:
		b.material = null
	frozen[2] = !frozen[2]

#upvote button
func _on_lever_pulled() -> void:
	await get_tree().create_timer(1.5).timeout #this would be spin animation time
	new_spin()
