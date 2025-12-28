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
	
	for child in grid.get_children():
		child.queue_free()
	
	#hardcoded
	var spacing: Vector2 = Vector2(250, 200)
	var scaling = 0.85
	var index = 0
	for x in range(3): #col
		for y in range(3): #row
			var s = TileDisplay.new(current_tiles[index])
			grid.add_child(s)
			
			s.name = str(index)
			s.position = Vector2(x * spacing.x, y * spacing.y)
			print(s.tooltip_trigger.position)
			s.scale.x = scaling
			s.scale.y = scaling
			
			index += 1

func _on_idle_finished(state: State) -> void:
	transition_to($Execute)

func _on_execute_finished(state: State) -> void:
	if frozen == [true, true, true] or spins_left == 0:
		finished.emit()
	else:
		transition_to($Idle)
