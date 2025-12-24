extends State

func _on_freeze_1_pressed() -> void:
	state_machine.frozen[0] = !state_machine.frozen[0]

func _on_freeze_2_pressed() -> void:
	state_machine.frozen[1] = !state_machine.frozen[1]

func _on_freeze_3_pressed() -> void:
	state_machine.frozen[2] = !state_machine.frozen[2]

func _on_lever_pulled() -> void:
	state_machine.spins_left -= 1

	var spins_counter := get_node("../../SpinsCounter")
	spins_counter.text = str(state_machine.spins_left)
	
	await get_tree().create_timer(1.5).timeout
	
	#which wheels we tryna spin
	for col in range(3):
		if not state_machine.frozen[col]:
			spin_wheel(col)
	
	#hacky?
	state_machine.update_current_tiles()
	
	#if state_machine.spins == 0 or state_machine.frozen == [true, true, true]:
	#	finished.emit(self) #needs a reason variable in here?
	finished.emit(self)

func spin_wheel(col: int) -> void:
	#what wheel
	var wheel: Array[TileEntity]
	match col:
		0: wheel = global.wheel_zero
		1: wheel = global.wheel_one
		2: wheel = global.wheel_two
		_: return
	
	#slice it
	var start_index = randi() % wheel.size()
	
	#adjust by 3
	var tiles_start = col * 3
	
	#update current_tiles
	for i in range(3):
		var current_index = (start_index + i) % wheel.size()
		state_machine.current_tiles[tiles_start + i] = wheel[current_index] as TileEntity
