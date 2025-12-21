extends Node2D

@onready var area_container = $Node2D
var current_area: Node = null
var level: int = 0
var money: int = 1000

func _ready() -> void:
	load_area("res://area/slots/slots.tscn")

func load_area(scene_path: String):
	if current_area:
		current_area.queue_free()
	
	var area_scene = load(scene_path)
	current_area = area_scene.instantiate()
	area_container.add_child(current_area)
