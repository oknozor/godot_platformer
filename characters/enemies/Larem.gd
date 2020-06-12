extends Character

export var GRAVITY = 300
export var SPEED = 30

var direction = -1.0

func _ready() -> void:
	_velocity = Vector2(-30.0, 0.0)
	set_physics_process(false)
	set_process(false)
	
func _physics_process(_delta: float) -> void:
	if is_on_wall():
		direction *= -1.0
	
	_velocity.y = GRAVITY * get_physics_process_delta_time()
	_velocity.x = lerp(_velocity.x, SPEED * direction, 0.05) 
	_velocity = move_and_slide(_velocity, UP)
