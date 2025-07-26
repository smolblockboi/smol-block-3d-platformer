extends Ability

@export var dive_speed : float = 14.0
@export var vertical_gain : float = 0.5

var action_held_down : bool
var dives_left : int = 1


func _process(delta: float) -> void:
	if player.action_state != player.ActionStates.ROLLING:
		action_held_down = false

	if not player.is_on_floor():
		if dives_left > 0:
			if Input.is_action_just_pressed("dive") and player.get_forward_input_value() > 0.5:
				dives_left -= 1
				player.velocity = Vector3.ZERO
				player.velocity += (player.get_model_forward_vector() + (Vector3.UP * vertical_gain)) * dive_speed
				action_held_down = true
		if action_held_down:
			if Input.is_action_pressed("dive"):
				player.move_speed = dive_speed
				player.action_state = player.ActionStates.ROLLING
		if Input.is_action_just_released("dive"):
			player.move_speed = player.run_speed
			player.action_state = player.ActionStates.IDLE
	else:
		if dives_left == 0:
			dives_left = 1
