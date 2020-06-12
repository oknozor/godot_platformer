extends Position2D

signal hit(position)

func _ready() -> void:
	set_visible(false)
	set_process(false)

func _process(_delta: float) -> void:
	var bodies = $HitBox.get_overlapping_bodies()
	for body in bodies:
		if body.has_node("Health") and not body.is_a_parent_of(self):
			body.get_node("Health").take_damage(1, get_parent())
			
			emit_signal("hit", body.position)

func swing(direction: Vector2):
	set_process(true)
	$"AnimationPlayer".play("attack")
	set_global_rotation(direction.angle())
	set_visible(true)
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'attack':
		set_visible(false)
		set_process(false)
