extends StateMachine

func _on_slot_finished(state: State) -> void:
	transition_to($Shop)
