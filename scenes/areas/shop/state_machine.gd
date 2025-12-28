extends StateMachine

var dir := DirAccess.open("res://assets/resources/tiles")

#get random tiles and splay them out
func update_tile_buys():
	var grid := get_node("../TileBuys")
	
	for child in grid.get_children():
		child.queue_free()
	
	var files = dir.get_files() 
	
	var scaling := 0.85
	
	for i in range(5):
		var file_name := files[randi() % files.size()] as String
		var path := "res://assets/resources/tiles/" + file_name
		
		var tile := TileEntity.new(load(path))
		var display := TileDisplay.new(tile)
		
		grid.add_child(display)
		
		display.name = str(i)
		display.position = Vector2(100 * i, -75 * i)
		display.scale = Vector2.ONE * scaling
