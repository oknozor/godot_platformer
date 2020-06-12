extends KinematicBody2D
class_name FlyingCharacter

export var ON_DAMAGE_KNOCK_BACK = 250

var _velocity = Vector2.ZERO;

func knock_back(source_position: Vector2):
	var knock_direction = source_position.direction_to(position)
	_velocity = ON_DAMAGE_KNOCK_BACK * knock_direction
		
func _on_Health_health_changed(new_health):
	if new_health == 0:
		emit_signal("died")
		queue_free()
