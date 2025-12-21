extends Node
@export var timer := 1.0
var points := 0
var row_value := 100
var stack: Array[QueuedEffect]
var last_tiles: Array[Tile]

const PATTERNS = [
	[0, 1, 2],  # col left
	[3, 4, 5],  # col middle
	[6, 7, 8],  # col right
	[0, 3, 6],  # row top
	[1, 4, 7],  # row middle
	[2, 5, 8],  # row bottom
	[0, 4, 8],  # diagonal pos slope
	[2, 4, 6]   # diagonal neg slope
]

#takes in the 9 tiles on grid to process
func queue(tiles: Array[Tile]) -> void:
	var order := 0
	last_tiles = tiles.duplicate() #dupe ts?
	
	#precalculate
	for i in range(tiles.size()):
		var tile := tiles[i]
		for pattern in PATTERNS:
			# Check if i is in the pattern AND the pattern matches
			if i in pattern and check_pattern(tiles, pattern, tile):
				var qe := QueuedEffect.new()
				qe.tile_index = i
				qe.urgency = 5
				qe.fx = "add_points"
				qe.arg = row_value
				qe.order = order
				order += 1
				stack.append(qe)
	
	#convert to QueuedEffects
	for tile_index in tiles.size():
		var tile := tiles[tile_index]
		for effect in tile.effects:
			for arg in effect.args:
				var qe := QueuedEffect.new()
				qe.tile_index = tile_index
				qe.urgency = effect.urgency
				qe.fx = effect.fx
				qe.arg = arg
				qe.order = order
				order += 1
				stack.append(qe)
	#sort
	sort_stack(stack)
	
	#calculate
	while stack.size() > 0:
		await get_tree().create_timer(timer).timeout
		var qe := stack.pop_front() as QueuedEffect
		calculate(qe)
	
	#postcalculate
	if get_parent().spins == 0:
		#go to shop
		return

# Helper function to check if a pattern matches for a given tile
func check_pattern(tiles: Array[Tile], pattern: Array, tile: Tile) -> bool:
	for index in pattern:
		if tiles[index] != tile:
			return false
	return true

func sort_stack(effects: Array[QueuedEffect]) -> Array[QueuedEffect]:
	var result := effects.duplicate()
	result.sort_custom(func(a: QueuedEffect, b: QueuedEffect):
		if a.urgency != b.urgency:
			return a.urgency > b.urgency
		#bookwise
		return a.order < b.order
	)
	return result

func calculate(qe: QueuedEffect) -> void:
	if qe.fx.is_empty():
		return
	if not has_method(qe.fx):
		push_error("Invalid effect method: %s" % qe.fx)
		return
	
	#hardcoded
	var grid := get_node("../Grid")
	grid.tiles[qe.tile_index].animate("score")
	call(qe.fx, qe.arg)
	var counter := get_node("../PointsCounter")
	counter.text = str(points)

#actual effects
func add_points(amount: int):
	points += amount

func copy(index: int):
	for effect in last_tiles[index].effects:
		for arg in effect.args:
			var qe := QueuedEffect.new()
			qe.tile_index = effect.tile_index
			qe.urgency = effect.urgency
			qe.fx = effect.fx
			qe.arg = arg
			await get_tree().create_timer(0.3).timeout #hardcode 0.3 sec
			calculate(qe)
