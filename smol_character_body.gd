class_name SmolCharacterBody extends CharacterBody3D

# Camera vars
@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@export var model_scene : Smol

@export var move_speed : float = 10.0
@export var acceleration : float = 30.0

@export var fall_speed : float = 30.0

enum BodyStates {IDLE, GROUND_POUND}
var body_state : BodyStates


func _unhandled_input(event: InputEvent) -> void:
	# Get mouse motion for camera if cursor is captured
	if event.is_action_pressed("capture_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity


func _process(delta: float) -> void:
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-30), deg_to_rad(30))
	
	twist_input = 0.0
	pitch_input = 0.0


func _physics_process(delta: float) -> void:
	var input_dir : Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var movement : Vector3 = Vector3(
		input_dir.x * move_speed, 
		-fall_speed * delta, 
		input_dir.y * move_speed
	)
	
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(twist_pivot.basis * movement, acceleration * delta)
	velocity.y = y_velocity + -fall_speed * delta
	
	move_and_slide()
	
	if input_dir:
		model_scene.look_at(model_scene.global_position - (twist_pivot.basis * Vector3(input_dir.x, 0.0, input_dir.y)))
