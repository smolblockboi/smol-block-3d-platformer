class_name Ability extends Node

var player : SmolCharacterBody

var is_active : bool


func _ready() -> void:
	player = get_parent()


func do_ability() -> void:
	pass
