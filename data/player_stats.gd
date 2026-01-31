class_name PlayerStats
extends Resource

@export_range(0, 99) var gold: int :
	set(value):
		gold = value
		emit_changed()

@export_range(0, 99) var xp: int :
	set(value):
		xp = value
		emit_changed()
		
@export_range(1, 10) var level: int :
	set(value):
		level = value
		emit_changed()
