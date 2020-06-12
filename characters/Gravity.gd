# This script as to be extended by every node with gravity
# `move_and_slide` is called only once here for gravity object
extends KinematicBody2D
class_name Gravity

export var GRAVITY = 500
var _velocity = Vector2.ZERO;

func _physics_process(delta: float) -> void:
	_velocity.y += GRAVITY * delta
	move_and_slide(_velocity, Vector2.UP)
