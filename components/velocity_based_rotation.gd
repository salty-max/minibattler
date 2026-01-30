class_name VelocityBasedRotation
extends Node

@export var target: Node2D
@export_range(0.25, 1.5) var lerp_duration := 0.4
@export var max_rotation_degrees := 40
@export var x_velocity_threshold := 3.0
@export var enabled: bool = true :
	set(value):
		enabled = value
		if target and not enabled:
			target.rotation = 0.0
			
var last_position: Vector2
var velocity: Vector2
var angle: float
var progress: float
var elapsed_time := 0.0


func _ready() -> void:
	assert(target, "No target set for VelocityBasedRotation component")


func _physics_process(delta: float) -> void:
	if not enabled or not target:
		return
		
	velocity = target.global_position - last_position
	last_position = target.global_position
	progress = elapsed_time / lerp_duration
	
	if abs(velocity.x) > x_velocity_threshold:
		angle = velocity.normalized().x * deg_to_rad(max_rotation_degrees)
	else:
		angle = 0.0
		
	target.rotation = lerp_angle(target.rotation, angle, progress)
	elapsed_time += delta
	
	if progress > 1.0:
		elapsed_time = 0.0
