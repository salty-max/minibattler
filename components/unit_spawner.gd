class_name UnitSpawner
extends Node

signal unit_spawned(unit: Unit)

const UNIT_SCENE := preload("res://scenes/unit.tscn")

@export var bench: PlayArea
@export var game_area: PlayArea


func _get_first_available_area() -> PlayArea:
	if not bench.unit_grid.is_grid_full():
		return bench
	elif not game_area.unit_grid.is_grid_full():
		return game_area
		
	return null


func spawn_unit(unit_data: UnitStats) -> void:
	var area := _get_first_available_area()
	# TODO throw popup error message
	assert(area, "No available space to add unit to")
	
	var unit: Unit = UNIT_SCENE.instantiate()
	var tile := area.unit_grid.get_first_empty_tile()
	
	area.unit_grid.add_child(unit)
	area.unit_grid.add_unit(tile, unit)
	unit.global_position = area.get_global_from_tile(tile) - Globals.HALF_CELL_SIZE
	unit.stats = unit_data
	
	unit_spawned.emit(unit)
