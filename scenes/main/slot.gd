extends State

@export var area: PackedScene
var area_instance: Node = null

func enter() -> void:
	area_instance = area.instantiate()
	add_child(area_instance)
	area_instance.get_node("StateMachine").finished.connect(_on_area_instance_finished)

func exit() -> void:
	area_instance.queue_free()
	area_instance = null

func _on_area_instance_finished():
	finished.emit(self)
