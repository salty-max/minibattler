class_name Arena
extends Node2D

@onready var unit_mover: UnitMover = $UnitMover
@onready var unit_spawner: UnitSpawner = $UnitSpawner


func _ready() -> void:
	unit_spawner.unit_spawned.connect(unit_mover.setup_unit)
