extends Ability

@export var jump_power : float = 10.0
@export var max_air_jumps : int = 1
var jumps_left : int = 0


func _physics_process(delta: float) -> void:
	if player.is_on_floor():
		jumps_left = max_air_jumps
		
	if Input.is_action_just_pressed("ui_accept") and !player.is_on_floor() and jumps_left:
		do_ability()


func do_ability():
	jumps_left -= 1
	player.velocity.y = jump_power
