class_name DiscardTrashManager
extends Node

@export var round_manager: RoundManager
@export var discard_trash_scene: PackedScene

func discard_any_trash() -> void:
	discard_trash_scene.instantiate()
