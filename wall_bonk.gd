extends Ability

@export var bonk_strength : float = 20.0


func _physics_process(delta: float) -> void:
	if player.is_on_wall() and player.action_state == player.ActionStates.ROLLING:
		print("bonked at %f" % player.last_frame_velocity.length())
		if player.last_frame_velocity.length() > bonk_strength * 0.5:
			player.velocity.y = bonk_strength
		else:
			player.velocity.y = bonk_strength * 0.5
		player.action_state = player.ActionStates.IDLE
