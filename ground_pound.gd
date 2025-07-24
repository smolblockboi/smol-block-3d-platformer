extends Ability

signal ground_pound_finished

@export var start_speed : float = 0.5
@export var fall_speed : float = 2.0

enum Phases {START, MIDDLE, END}
var phase : Phases


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ground_pound") and !player.is_on_floor():
		if player.body_state != player.BodyStates.GROUND_POUND:
			do_ability()

	if is_active:
		match phase:
			Phases.START:
				player.fall_speed *= -start_speed
				if player.velocity.y < fall_speed:
					phase = Phases.MIDDLE
			Phases.MIDDLE:
				player.fall_speed *= fall_speed
			Phases.END:
				pass

	if player.is_on_floor():
		ground_pound_finished.emit()


func do_ability():
	ground_pound_finished.connect(_on_ground_pound_finished, CONNECT_ONE_SHOT)

	player.velocity = Vector3.ZERO

	player.body_state = player.BodyStates.GROUND_POUND

	phase = Phases.START


func _on_ground_pound_finished() -> void:
	player.body_state = player.BodyStates.IDLE
	phase = Phases.END
