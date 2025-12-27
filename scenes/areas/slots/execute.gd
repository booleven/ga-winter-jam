extends State

@export var timer := 0.75
var points := 0
var row_value := 100 #3iar base amount
var stack: Array[EffectEntity]

# ===== STATE =====

func enter() -> void:
	if state_machine.frozen == [true, true, true] or state_machine.spins_left == 0:
		queue_3iar()
		queue_afx()
	else:
		queue_pfx()
	
	sort_stack()
	await execute_stack()
	
	#animations abt scoring done
	
	
	finished.emit(self)

# ===== HELPERS =====

#this could be an enum instead, but this should be ok
const PATTERNS = {
	"col_left": [0, 1, 2],
	"col_middle": [3, 4, 5],
	"col_right": [6, 7, 8],
	"row_top": [0, 3, 6],
	"row_middle": [1, 4, 7],
	"row_bottom": [2, 5, 8],
	"diagonal_pos": [0, 4, 8],
	"diagonal_neg": [2, 4, 6]
}

func queue_3iar() -> void:
	var tiles := state_machine.current_tiles as Array[TileEntity]
	
	#first 8 patterns always the 3iar
	var pattern_keys := PATTERNS.keys()
	for i in range(8):
		var pattern := PATTERNS[pattern_keys[i]] as Array
		
		if check_pattern(tiles, pattern, tiles[pattern[0]]):
			#append effect entity for each tile entity in the matching pattern
			for tile_index in pattern:
				var er := EffectResource.new()
				er.method = "add_points"
				er.args = [row_value]
				er.urgency = 5 #just set urgency high
				
				var ee := EffectEntity.new(er, tile_index)
				stack.append(ee)

#queue passive effect entities
func queue_pfx() -> void:
	var tiles := state_machine.current_tiles as Array[TileEntity]
	
	for tile_index in tiles.size():
		var tile := tiles[tile_index]
		for effect_resource in tile.pfx:
			var ee := EffectEntity.new(effect_resource, tile_index)
			stack.append(ee)

#queue active effect entities
func queue_afx() -> void:
	var tiles := state_machine.current_tiles as Array[TileEntity]
	
	for tile_index in tiles.size():
		var tile := tiles[tile_index]
		for effect_resource in tile.afx:
			var ee := EffectEntity.new(effect_resource, tile_index)
			stack.append(ee)

#checks if a single tile entity is in a pattern
func check_pattern(tiles: Array[TileEntity], pattern: Array, tile: TileEntity) -> bool:
	for index in pattern:
		if tiles[index].name != tile.name:
			return false
	return true

#sorts stack by urgency (high to low), then by tile_index (low to high)
func sort_stack() -> void:
	stack.sort_custom(func(a: EffectEntity, b: EffectEntity):
		if a.urgency != b.urgency:
			return a.urgency > b.urgency
		return a.tile_index < b.tile_index
	)

#execute effect entity
func execute(ee: EffectEntity) -> void:
	if ee.method.is_empty():
		return
	if not has_method(ee.method):
		push_error("effect has nonexistant method: %s" % ee.method)
		return
	
	#animate tile
	var grid := get_node("../../Grid")
	if grid and ee.tile_index < grid.tiles.size():
		grid.tiles[ee.tile_index].animate("score")
	
	#actual execution here
	call(ee.method, ee.args)
	
	#counter
	var counter := get_node("../../PointsCounter")
	if counter:
		counter.text = str(points)

func execute_stack() -> void:
	while stack.size() > 0:
		var ee := stack.pop_front() as EffectEntity
		print(stack)
		execute(ee)
		await get_tree().create_timer(timer).timeout

# ===== ACTUAL EFFECT METHODS =====

#we could make an enum here for every method name, might be long tho

func add_points(args: Array) -> void:
	var amount: int = args[0]
	points += amount

func copy(args: Array) -> void:
	var index: int = args[0]
	var tiles := state_machine.current_tiles as Array[TileEntity]
	
	for effect_resource in tiles[index].afx:
		var ee := EffectEntity.new(effect_resource, index)
		await get_tree().create_timer(0.3).timeout
		execute(ee)
	
