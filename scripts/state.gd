class_name State extends Node

signal finished(state: State)

var state_machine: StateMachine

func _ready() -> void:
	state_machine = self.get_parent()

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(delta: float) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	pass
