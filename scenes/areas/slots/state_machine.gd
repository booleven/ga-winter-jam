extends StateMachine

var frozen := [false, false, false]
var current_tiles: Array[TileEntity] = []
var spins_left := 5

signal finished()

func _ready() -> void:
	current_tiles.resize(9)

func _process(delta: float) -> void:
	$"../Label".text = current_state.name

func update_current_tiles():
	var grid := get_node("../Grid")
	
	for i in range(9):
		var tile_display: TileDisplay = grid.tiles[i]
		var tile := current_tiles[i]
		
		if tile == null:
			tile_display.sprite.texture = null
		else:
			tile_display.sprite.texture = tile.texture

func _on_idle_finished(state: State) -> void:
	transition_to($Execute)

func _on_execute_finished(state: State) -> void:
	if frozen == [true, true, true] or spins_left == 0:
		finished.emit()
	else:
		transition_to($Idle)
