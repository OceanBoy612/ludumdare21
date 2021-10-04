extends TileMap


var BREAKABLE_TILES = [1]


func break_tile(impact_point: Vector2):
	# find the tile that should be broken. and delete it.
#	var impact_point: Vector2 = col.position - (col.normal * 4)
	
	var cell_coord = world_to_map(impact_point)
	var cell_id = get_cellv(cell_coord)
	
	if cell_id in BREAKABLE_TILES:
		$BreakSound.play()
		set_cellv(cell_coord, -1)
		
#		var frag = Sprite.new()
#		frag.texture = tile_set.tile_get_texture(cell_id)


