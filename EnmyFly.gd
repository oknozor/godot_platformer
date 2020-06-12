extends FlyingCharacter

export(float) var MASS = 1.4
export(float) var FOLLOW_SPEED = 80.0
export(float) var FOLLOW_RANGE = 150.0
export(float) var RETURN_SPEED = 80.0
export(float) var SLOW_RADIUS = 70.0
export(float) var ARRIVE_DISTANCE = 3.0
export(float) var ATTACK_CHARGE_TIMER = 0.5

enum STATE { IDLE, FOLLOW, RETURN, KNOCKED_BACK }
var state = null
var target_position = Vector2()
var has_target = false
var spawn_position = Vector2()

func _ready() -> void:
	spawn_position = position
	var target_node = get_tree().get_root().get_node('World').get_node('Player')
	if not target_node:
		print("Error getting target node %s" % target_node)
		return 
	target_node.connect('position_changed', self, '_on_target_position_changed')
	target_node.connect('died', self, '_on_target_died')
	has_target = true
	_change_state(STATE.IDLE)
	
func _change_state(new_state):
	state = new_state

func _physics_process(delta: float) -> void:
	match state:
		STATE.IDLE: 
			_velocity = Vector2.ZERO
			var distance_to_target = position.distance_to(target_position)
			if has_target and distance_to_target < FOLLOW_RANGE:
				_change_state(STATE.FOLLOW)
		STATE.FOLLOW:
			var distance_to_target = follow()
			if distance_to_target > FOLLOW_RANGE:
				_change_state(STATE.RETURN)
		STATE.RETURN:
			var distance_to_target = arrive_to()
			if distance_to_target < ARRIVE_DISTANCE:
				_change_state(STATE.IDLE)
				
	move_and_slide(_velocity)
		
func follow() -> float:
	var desired_velocity = (target_position - position).normalized() * FOLLOW_SPEED
	var steering = (desired_velocity - _velocity) / MASS 
	_velocity = lerp(_velocity, _velocity + steering, 0.2)
	return position.distance_to(target_position)

func arrive_to() -> float:
	var desired_velocity = (spawn_position - position).normalized() * RETURN_SPEED
	var distance_to_target = position.distance_to(spawn_position)
	
	if distance_to_target < SLOW_RADIUS:
		desired_velocity *= (distance_to_target / SLOW_RADIUS) * 0.75 + 0.25
	var steering = (desired_velocity - _velocity) / MASS 
	_velocity = lerp(_velocity, _velocity + steering, 0.2)
	return distance_to_target
	
func _on_target_position_changed(position):
	target_position = position
	
func _on_target_died():
	target_position = Vector2()
	has_target = false
	_change_state(STATE.RETURN)
