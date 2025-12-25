extends Node #globals scripts aren't the best, may rework this entire global

var level: int = 0
var money: int = 1000
var wheel_zero: Array[TileEntity]
var wheel_one: Array[TileEntity]
var wheel_two: Array[TileEntity]

#hardcoded
var initial_tile_resources: Array[TileResource] = [
	preload("res://assets/resources/tiles/clubs.tres"),
	preload("res://assets/resources/tiles/diamonds.tres"),
	preload("res://assets/resources/tiles/hearts.tres"),
	preload("res://assets/resources/tiles/spades.tres")
]

func _init() -> void:
	for tr in initial_tile_resources:
		wheel_zero.append(TileEntity.new(tr))
		wheel_one.append(TileEntity.new(tr))
		wheel_two.append(TileEntity.new(tr))
	#shuffle initial order; we don't do this every spin anymore
	wheel_zero.shuffle()
	wheel_one.shuffle()
	wheel_two.shuffle()

signal go_shop
signal go_slots
