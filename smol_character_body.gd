class_name SmolCharacterBody extends CharacterBody3D

@onready var state_label: Label = %StateLabel
@onready var double_jump_label: Label = %DoubleJumpLabel
@onready var dive_label: Label = %DiveLabel


# Camera vars
@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot
var mouse_sensitivity := 0.001
var controller_sensitivity := 0.075
var twist_input := 0.0
var pitch_input := 0.0

@export var model_scene : Smol

@export var run_speed : float = 9
var move_speed : float = 9

@export var acceleration : float = 30.0
var move_acceleration : float = 30

@export var fall_speed : float = 30.0

enum ActionStates {IDLE, ROLLING}
var action_state : ActionStates

var input_dir : Vector2

var last_frame_velocity : Vector3


func _unhandled_input(event: InputEvent) -> void:
	# Get mouse motion for camera if cursor is captured
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			get_tree().quit()

	if event is InputEventJoypadButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity


func _process(delta: float) -> void:
	var camera_input := Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	if abs(camera_input.x) >= InputMap.action_get_deadzone("camera_left"):
		twist_input = -camera_input.x * controller_sensitivity
	if abs(camera_input.y) >= InputMap.action_get_deadzone("camera_up"):
		pitch_input = -camera_input.y * controller_sensitivity

	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-30), deg_to_rad(30))

	twist_input = 0.0
	pitch_input = 0.0


func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if action_state == ActionStates.ROLLING:
		input_dir.y = -1


	var movement : Vector3 = Vector3(
		input_dir.x * move_speed,
		-fall_speed * delta,
		input_dir.y * move_speed
	)

	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(twist_pivot.basis * movement, acceleration * delta)
	velocity.y = y_velocity + -fall_speed * delta

	last_frame_velocity = velocity

	move_and_slide()

	if input_dir:
		model_scene.look_at(model_scene.global_position - (twist_pivot.basis * Vector3(input_dir.x, 0.0, input_dir.y)))

	state_label.text = "Action State: %s" % ActionStates.keys()[action_state].to_upper()
	double_jump_label.text = "Can Double Jump: %s" % str($DoubleJump.jumps_left > 0).to_upper()
	dive_label.text = "Can Dive: %s" % str($Dive.dives_left > 0).to_upper()


func get_model_forward_vector() -> Vector3:
	return model_scene.global_basis.z

func get_forward_input_value() -> float:
	return (input_dir.y * get_model_forward_vector()).length()
