extends Ability

@export var roll_speed : float = 20.0
@export var roll_start_threshold : float = 8.0


func _process(delta: float) -> void:
	if player.is_on_floor():
		if player.get_real_velocity().length() >= roll_start_threshold:
			if Input.is_action_pressed("dive"):
				player.move_speed = roll_speed
				player.action_state = player.ActionStates.ROLLING
		if Input.is_action_just_released("dive"):
			player.move_speed = player.run_speed
			player.action_state = player.ActionStates.IDLE
