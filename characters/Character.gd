extends Gravity
class_name Character

signal position_changed
signal died

export var ON_DAMAGE_KNOCK_BACK = 40

var previous_direction = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	emit_signal("position_changed", position)
	
func knock_back(source_position: Vector2):
	var knock_direction = source_position.direction_to(position)
	_velocity = ON_DAMAGE_KNOCK_BACK * knock_direction
		
func _on_Health_health_changed(new_health):
	if new_health == 0:
		emit_signal("died")
		queue_free()
