class_name DiscardTrashManager
extends Node

@export var round_manager: RoundManager
@export var discard_trash_scene: PackedScene

var discard_trash: DiscardTrash

func discard_any_trash() -> void:
	discard_trash = discard_trash_scene.instantiate()
	add_child(discard_trash)
