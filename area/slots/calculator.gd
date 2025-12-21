extends Node

@export var timer := 1.0
var points := 0

#takes in the 9 tiles on grid to process
func stack(tiles: Array[Tile]) -> void:
	var flat: Array[QueuedEffect] = []
	var order := 0

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
				flat.append(qe)

	#sort
	var effect_queue := sort_stack(flat)

	#do until empty
	while effect_queue.size() > 0:
		await get_tree().create_timer(timer).timeout
		var qe := effect_queue.pop_front() as QueuedEffect #explicity put this for no error
		calculate(qe)

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
	grid.tiles[qe.tile_index].animate("score") #idle, score, freeze
	call(qe.fx, qe.arg) #this is actually calculating
	var counter := get_node("../Counter")
	counter.text = str(points)

#actual effects
func add_points(amount: int):
	points += amount
	return
