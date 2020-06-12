extends Area2D

func _process(_delta: float) -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.has_node("Health") and not body.is_a_parent_of(self):
			body.get_node("Health").take_damage(1, self)
