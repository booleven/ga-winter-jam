extends Node

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

	call(qe.fx, qe.arg)


#actual effects
func add_points(amount: int):
	return

func multiply_points(multiplier: int):
	return

func add_spins(amount: int):
	return
