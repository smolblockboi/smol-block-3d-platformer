class_name Smol extends Node3D

@export var character_controller : CharacterBody3D:
	set(body):
		character_controller = body
@export var animation_tree : AnimationTree:
	set(anim_tree):
		animation_tree = anim_tree


func _process(delta: float) -> void:
	if character_controller:
		if animation_tree:
			animation_tree.set(
				"parameters/Walk_Run_Blendspace/blend_position",
				(character_controller.velocity * Vector3(1.0, 0.0, 1.0)).length()
			)
			animation_tree.set(
				"parameters/Jump_Fall_Blendspace/blend_position",
				character_controller.velocity.y
			)
