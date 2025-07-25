extends Area3D

@export_file("*.tscn") var level_path : String

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body : Node3D) -> void:
	if body is SmolCharacterBody:
		get_tree().call_deferred("change_scene_to_file", level_path)
