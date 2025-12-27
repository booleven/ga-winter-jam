extends State

@export var area: PackedScene
var area_instance: Node = null

func enter() -> void:
	area_instance = area.instantiate()
	add_child(area_instance)

func exit() -> void:
	area_instance.queue_free()
	area_instance = null #kill
