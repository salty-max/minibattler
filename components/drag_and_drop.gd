class_name DragAndDrop
extends Node

signal drag_canceled(start_pos: Vector2)
signal drag_started
signal dropped(start_pos: Vector2)

@export var enabled := true
@export var target: Area2D

var starting_position: Vector2
var offset := Vector2.ZERO
var dragging := false


func _ready() -> void:
	assert(target, "No target set for DragAndDrop component")
	target.input_event.connect(_on_target_input_event.unbind(1))
	
	
func _process(_delta: float) -> void:
	if dragging and target:
		target.global_position = target.get_global_mouse_position() + offset
		
		
func _input(event: InputEvent) -> void:
	if dragging:
		if event.is_action_pressed("cancel_drag"):
			_cancel_drag()
		elif event.is_action_released("select"):
			_drop()
		
		
func _end_drag() -> void:
	dragging = false
	target.remove_from_group("dragging")
	target.z_index = 0
	
	
func _cancel_drag() -> void:
	_end_drag()
	drag_canceled.emit(starting_position)
	
	
func _start_drag() -> void:
	dragging = true
	starting_position = target.global_position
	target.add_to_group("dragging")
	target.z_index = 10
	offset = target.global_position - target.get_global_mouse_position()
	drag_started.emit()
	
	
func _drop() -> void:
	_end_drag()
	dropped.emit(starting_position)
	
	
func _on_target_input_event(_viewport: Node, event: InputEvent) -> void:
	if not enabled:
		return
	
	if not dragging:
		var dragging_object := get_tree().get_first_node_in_group("dragging")
		if dragging_object:
			return
		elif event.is_action_pressed("select"):
			_start_drag()
	
