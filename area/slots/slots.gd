extends Node2D
class_name Slot

@export var total_tiles: Array[Tile] = []
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

func update_visuals():
	var grid := get_node("Grid")

	for i in range(9):
		var sprite := grid.get_node(str(i))
		var tile := current_tiles[i]

		if tile == null:
			sprite.texture = null
		else:
			sprite.texture = tile.texture

#upvote button
func _on_button_pressed() -> void:
	new_spin()

func _on_freeze_1_pressed():
	frozen[2] = !frozen[2]


func _on_freeze_2_pressed() -> void:
	frozen[1] = !frozen[1]


func _on_freeze_3_pressed() -> void:
	frozen[0] = !frozen[0]
