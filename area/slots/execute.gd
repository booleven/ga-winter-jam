extends State
@export var timer := 1.0
@export var is_afx_spin := true  # Set this to determine spin type
var points := 0
var row_value := 100
var stack: Array[EffectEntity]

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

func enter() -> void:
	print("poop")
	if is_afx_spin:
		check_three_in_a_row()
		queue_afx()
	else:
		queue_pfx()
	
	await execute_stack()
	
	#postexecute here!
	finished.emit(self)

func check_three_in_a_row() -> void:
	var tiles := state_machine.current_tiles as Array[TileEntity]
	
	# Loop through first 8 patterns only
	var pattern_keys := PATTERNS.keys()
	for i in range(8):
		var pattern := PATTERNS[pattern_keys[i]] as Array
		
		# Check if this pattern matches (all 3 tiles are the same)
		if check_pattern(tiles, pattern, tiles[pattern[0]]):
			# Add effect to ALL tiles in the matching pattern
			for tile_index in pattern:
				var er := EffectResource.new()
				er.method = "add_points"
				er.args = [row_value]
				er.urgency = 5  # High urgency for row matches
				
				var ee := EffectEntity.new(er, tile_index)
				stack.append(ee)

# Queue passive effects (pfx)
func queue_pfx() -> void:
	var tiles := state_machine.current_tiles as Array[TileEntity]
	
	# Create EffectEntities from pfx
	for tile_index in tiles.size():
		var tile := tiles[tile_index]
		for effect_resource in tile.pfx:
			var ee := EffectEntity.new(effect_resource, tile_index)
			stack.append(ee)
	
	sort_stack()

# Queue active effects (afx)
func queue_afx() -> void:
	var tiles := state_machine.current_tiles as Array[TileEntity]
	
	# Create EffectEntities from afx
	for tile_index in tiles.size():
		var tile := tiles[tile_index]
		for effect_resource in tile.afx:
			var ee := EffectEntity.new(effect_resource, tile_index)
			stack.append(ee)
	
	sort_stack()

# Helper to execute the entire stack with delays
func execute_stack() -> void:
	while stack.size() > 0:
		await get_tree().create_timer(timer).timeout
		var ee := stack.pop_front() as EffectEntity
		print(stack)
		execute(ee)

# Helper function to check if a pattern matches for a given tile
func check_pattern(tiles: Array[TileEntity], pattern: Array, tile: TileEntity) -> bool:
	for index in pattern:
		if tiles[index].name != tile.name:
			return false
	return true

# Sort stack by urgency (high to low), then by tile_index (low to high)
func sort_stack() -> void:
	stack.sort_custom(func(a: EffectEntity, b: EffectEntity):
		if a.urgency != b.urgency:
			return a.urgency > b.urgency
		# For same urgency, sort by tile_index (bookwise order)
		return a.tile_index < b.tile_index
	)

# Execute a single effect
func execute(ee: EffectEntity) -> void:
	if ee.method.is_empty():
		return
	if not has_method(ee.method):
		push_error("Invalid effect method: %s" % ee.method)
		return
	
	# Animate the tile
	var grid := get_node("../../Grid")
	if grid and ee.tile_index < grid.tiles.size():
		grid.tiles[ee.tile_index].animate("score")
	
	# Execute the effect with args
	call(ee.method, ee.args)
	
	# Update counter
	var counter := get_node("../../PointsCounter")
	if counter:
		counter.text = str(points)

# ===== ACTUAL EFFECT METHODS =====

func add_points(args: Array) -> void:
	var amount: int = args[0]
	points += amount

func copy(args: Array) -> void:
	var index: int = args[0]
	var tiles := state_machine.current_tiles as Array[TileEntity]
	
	# Copy all afx from the tile at the specified index
	for effect_resource in tiles[index].afx:
		var ee := EffectEntity.new(effect_resource, index)
		await get_tree().create_timer(0.3).timeout
		execute(ee)
