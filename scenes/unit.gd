@tool
class_name Unit
extends Area2D

signal quick_sell_pressed

@onready var skin: Sprite2D = %Skin
@onready var health_bar: ProgressBar = %HealthBar
@onready var mana_bar: ProgressBar = %ManaBar
@onready var drag_and_drop: DragAndDrop = %DragAndDrop
@onready var velocity_based_rotation: VelocityBasedRotation = %VelocityBasedRotation
@onready var outline_highlighter: OutlineHighlighter = %OutlineHighlighter

@export var stats: UnitStats :
	set(value):
		if value == null:
			stats = null
			return
		
		stats = value.duplicate()
			
		if not is_node_ready():
			await ready
		
		skin.texture.region.position = Vector2(stats.skin_coordinates) * Globals.CELL_SIZE

var is_hovered := false


func _ready() -> void:
	if not Engine.is_editor_hint():
		drag_and_drop.drag_started.connect(_on_drag_started)
		drag_and_drop.drag_canceled.connect(_on_drag_canceled)
		drag_and_drop.dropped.connect(_on_dropped)
		
		
func _input(event: InputEvent) -> void:
	if not is_hovered:
		return
		
	if event.is_action_pressed("quick_sell"):
		quick_sell_pressed.emit()
		
		
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
		
	is_hovered = true
	outline_highlighter.highlight()
	z_index = 1


func _on_mouse_exited() -> void:
	if drag_and_drop.dragging:
		return
		
	is_hovered = false
	outline_highlighter.clear_highlight()
	z_index = 0
