extends Node

var health = 0
export var max_health = 3
signal health_changed

#func _ready() -> void:
#	health = max_health
	
func take_damage(amount):
	health -= amount
	if health < 0:
		health = 0
	print(health)
	emit_signal("health_changed", health)

func heal(amount):
	health += amount
	if health > max_health:
		health = max_health	
	emit_signal("health_changed", health)
