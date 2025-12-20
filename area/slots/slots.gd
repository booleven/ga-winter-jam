extends Node2D
class_name Slot

@export var total_tiles: Array[Tile] = []
var current_tiles: Array[Tile] = []
var points: int

func _ready():
	return #nun yet?

#spinning time export? do animation call, then logic
#await get_tree().create_timer(1.0).timeout
func new_spin():
	randomize()
	total_tiles.append_array(current_tiles)
	current_tiles.clear()
	total_tiles.shuffle()
	
	#transfer first 9 in total to current
	for i in range(9):
		current_tiles.append(total_tiles.pop_front())
		#grid -> node i -> sprite2d -> set texture to current_tile i's texture
		get_node("Grid").get_node(str(i)).texture = current_tiles[i].texture

#upvote button
func _on_button_pressed() -> void:
	new_spin()
