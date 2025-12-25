extends Node2D

@onready var area_container = $Node2D
var current_area: Node = null

func _ready() -> void:
	load_area("res://scenes/areas/slots/slots.tscn")
	global.go_shop.connect(on_go_shop_triggered)
	global.go_slots.connect(on_go_slots_triggered)

func load_area(scene_path: String):
	if current_area:
		current_area.queue_free()
	
	var area_scene = load(scene_path)
	current_area = area_scene.instantiate()
	area_container.add_child(current_area)

func on_go_shop_triggered():
	load_area("res://scenes/areas/shop/shop.tscn")

func on_go_slots_triggered():
	load_area("res://scenes/areas/slots/slots.tscn")
