class_name UnitMover
extends Node

@export var play_areas: Array[PlayArea]


func _get_play_area_from_position(global: Vector2) -> int:
	var dropped_area_idx := -1
	
	for i in play_areas.size():
		var tile := play_areas[i].get_tile_from_global(global)
		if play_areas[i].is_tile_in_bounds(tile):
			dropped_area_idx = i
			
	return dropped_area_idx
	
	
func _reset_unit_to_starting_position(start_pos: Vector2, unit: Unit) -> void:
	var idx := _get_play_area_from_position(start_pos)
	var tile := play_areas[idx].get_tile_from_global(start_pos)
	
	unit.reset_after_drag(start_pos)
	play_areas[idx].unit_grid.add_unit(tile, unit)
	
	
func _move_unit(unit: Unit, play_area: PlayArea, tile: Vector2i) -> void:
	play_area.unit_grid.add_unit(tile ,unit)
	unit.global_position = play_area.get_global_from_tile(tile) - Globals.HALF_CELL_SIZE
	unit.reparent(play_area.unit_grid)
