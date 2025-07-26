extends Ability

@export var jump_power : float = 12.0


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		do_ability()


func do_ability():
	player.velocity.y = jump_power
