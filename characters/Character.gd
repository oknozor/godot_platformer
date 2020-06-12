extends KinematicBody2D
class_name Character

const UP = Vector2.UP

export var speed = Vector2(150, 175)
export var ON_DAMAGE_KNOCK_BACK = 40

var previous_direction = Vector2.RIGHT
var _velocity = Vector2.ZERO;
	
func knock_back(source_position: Vector2):
	if position.x < source_position.x:
		_velocity.x -= ON_DAMAGE_KNOCK_BACK
	else:
		_velocity.x += ON_DAMAGE_KNOCK_BACK
		
func _on_Health_health_changed(new_health):
	if new_health == 0:
		queue_free()
