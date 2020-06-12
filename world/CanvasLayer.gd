extends CanvasLayer

func _on_Health_health_changed(health) -> void:
	match health:
		0: 
			$Hud/Lifebar/full_heart1.set_visible(false)
		1: 
			$Hud/Lifebar/full_heart1.set_visible(true)
			$Hud/Lifebar/full_heart2.set_visible(false)
		2: 
			$Hud/Lifebar/full_heart2.set_visible(true)
			$Hud/Lifebar/full_heart3.set_visible(false)
		3: 
			$Hud/Lifebar/full_heart3.set_visible(true)
