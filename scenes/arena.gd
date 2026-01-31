class_name Arena
extends Node2D

@onready var unit_mover: UnitMover = $UnitMover
@onready var unit_spawner: UnitSpawner = $UnitSpawner
@onready var sell_portal: SellPortal = $SellPortal


func _ready() -> void:
	unit_spawner.unit_spawned.connect(_on_unit_spawned)
	unit_spawner.spawn_unit(preload("res://data/units/namzar.tres"))
	
	
func _on_unit_spawned(unit: Unit) -> void:
	unit_mover.setup_unit(unit)
	sell_portal.setup_unit(unit)
