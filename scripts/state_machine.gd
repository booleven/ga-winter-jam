class_name StateMachine extends Node

@export var current_state: State #export works as initial

func _ready() -> void:
	transition_to(current_state) #_process won't tick before

func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func transition_to(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
