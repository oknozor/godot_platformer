extends Character

export var DASH_SPEED = 300
export var WALK_SPEED = 150
export var JUMP_FORCE = 350
export var KNOCK_BACK = 40
export var POGO = 150
export var STOMP_FORCE = 100
export (float, 0, 1.0) var FRICTION = 0.25
export (float, 0, 1.0) var AIR_FRICTION = 0.6
export (float, 0, 1.0) var AIR_ACCELERATION = 0.6
export (float, 0, 1.0) var ACCELERATION = 0.25

export var JUMP_COUNT = 2
export var DASH_ENABLED = true
export var DASH_TIME = 0.33

var _jump_counter = 2
var _dashing = false
var _can_dash = true
var _dash_acc = 0
var _previous_x_dir = 1.0

func _physics_process(delta: float) -> void:
	var input_direction = get_input_direction()
	update_helper(input_direction)
	update_and_move(input_direction, delta)

func update_and_move(direction: Vector2, delta: float) -> void:
	if _dashing:
		_dash_acc += delta
		if _dash_acc >= DASH_TIME:
			_dashing = false
			_dash_acc = 0
	elif is_on_floor():
		_velocity.y = 0
		_jump_counter = JUMP_COUNT
		
	if direction.x != 0:
		_velocity.x = lerp(_velocity.x, direction.x * WALK_SPEED, ACCELERATION)
	else: 
		_velocity.x = lerp(_velocity.x, 0, FRICTION)
		
	var can_jump = (is_on_floor() or JUMP_COUNT > 1) and _jump_counter > 0
	
	if can_jump and Input.is_action_just_pressed("jump"):
		_jump_counter -= 1
		_velocity.y = lerp(_velocity.y, -JUMP_FORCE, AIR_ACCELERATION)
	elif _velocity.y < 0 and Input.is_action_just_released("jump"):
		_velocity.y = lerp(_velocity.y, 0, AIR_FRICTION)
	elif DASH_ENABLED and Input.is_action_pressed("dash"):
		_dashing = true
		_velocity.y = 0
		_velocity.x = DASH_SPEED * _previous_x_dir
	elif Input.is_action_just_pressed("attack"):
		if direction == Vector2.ZERO:
			$Sword.swing(Vector2(_previous_x_dir, 0))
		else: 
			$Sword.swing(direction)
			
	elif is_on_ceiling():
		_velocity.y = lerp(_velocity.y, 0, FRICTION)
		
	
	
func get_input_direction() -> Vector2: 
	var x_dir = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if x_dir != 0: 
		_previous_x_dir = x_dir
		
	return Vector2(
		x_dir,
		int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	)

func update_helper(input_direction: Vector2) -> void:
	if input_direction == Vector2.ZERO:
		$ArrowIndicator.set_visible(false)
	else: 
		$ArrowIndicator.set_visible(true)
		$ArrowIndicator.set_global_rotation(input_direction.angle())


func _on_Sword_hit(enemy_position) -> void:
	if position.y < enemy_position.y:
		_velocity.y = -POGO
	else:
		if position.x < enemy_position.x:
			_velocity.x -= KNOCK_BACK
		else:
			_velocity.x += KNOCK_BACK
