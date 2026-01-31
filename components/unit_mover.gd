class_name UnitMover
extends Node

@export var play_areas: Array[PlayArea]


func _ready() -> void:
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		setup_unit(unit)


func setup_unit(unit: Unit) -> void:
	unit.drag_and_drop.drag_started.connect(_on_unit_drag_started.bind(unit))
	unit.drag_and_drop.drag_canceled.connect(_on_unit_drag_canceled.bind(unit))
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))
	
	
func _set_highlighters(enabled: bool) -> void:
	for play_area in play_areas:
		play_area.tile_highlighter.enabled = enabled


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
	
	
func _on_unit_drag_started(unit: Unit) -> void:
	_set_highlighters(true)
	
	var idx := _get_play_area_from_position(unit.global_position)
	if idx > -1:
		var tile := play_areas[idx].get_tile_from_global(unit.global_position)
		play_areas[idx].unit_grid.remove_unit(tile)
	
	
func _on_unit_drag_canceled(start_pos: Vector2, unit: Unit) -> void:
	_set_highlighters(false)
	_reset_unit_to_starting_position(start_pos, unit)
	
	
func _on_unit_dropped(start_pos: Vector2, unit: Unit) -> void:
	_set_highlighters(false)
	
	var old_idx := _get_play_area_from_position(start_pos)
	var drop_idx := _get_play_area_from_position(unit.get_global_mouse_position())
	
	if drop_idx == -1:
		_reset_unit_to_starting_position(start_pos, unit)
		return
	
	var old_area = play_areas[old_idx]
	var old_tile := old_area.get_tile_from_global(start_pos)
	var drop_area := play_areas[drop_idx]
	var drop_tile := drop_area.get_hovered_tile()
	
	if drop_area.unit_grid.is_tile_occupied(drop_tile):
		var old_unit := drop_area.unit_grid.units[drop_tile]
		drop_area.unit_grid.remove_unit(drop_tile)
		_move_unit(old_unit, old_area, old_tile)
	
	_move_unit(unit, drop_area, drop_tile)
