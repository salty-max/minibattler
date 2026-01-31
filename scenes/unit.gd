@tool
class_name Unit
extends Area2D

@onready var skin: Sprite2D = %Skin
@onready var health_bar: ProgressBar = %HealthBar
@onready var mana_bar: ProgressBar = %ManaBar
@onready var drag_and_drop: DragAndDrop = %DragAndDrop
@onready var velocity_based_rotation: VelocityBasedRotation = %VelocityBasedRotation
@onready var outline_highlighter: OutlineHighlighter = %OutlineHighlighter


func _ready() -> void:
	if not Engine.is_editor_hint():
		drag_and_drop.drag_started.connect(_on_drag_started)
		drag_and_drop.drag_canceled.connect(_on_drag_canceled)
		drag_and_drop.dropped.connect(_on_dropped)


@export var stats: UnitStats :
	set(value):
		if value == null:
			stats = null
			return
		
		stats = value.duplicate()
			
		if not is_node_ready():
			await ready
		
		skin.texture.region.position = Vector2(stats.skin_coordinates) * Globals.CELL_SIZE
		
		
func reset_after_drag(start_pos: Vector2) -> void:
	velocity_based_rotation.enabled = false
	global_position = start_pos
	
	
func _on_drag_started() -> void:
	velocity_based_rotation.enabled = true
	
	
func _on_drag_canceled(start_pos: Vector2) -> void:
	reset_after_drag(start_pos)
	
	
func _on_dropped(_start_pos: Vector2) -> void:
	velocity_based_rotation.enabled = false
	
	
func _on_mouse_entered() -> void:
	if drag_and_drop.dragging:
		return
		
	outline_highlighter.highlight()
	z_index = 1


func _on_mouse_exited() -> void:
	if drag_and_drop.dragging:
		return
		
	outline_highlighter.clear_highlight()
	z_index = 0
