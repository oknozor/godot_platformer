extends Label

func _ready() -> void:
	pass
	
func _on_Player_state_changed(state_name) -> void:
	text = state_name
