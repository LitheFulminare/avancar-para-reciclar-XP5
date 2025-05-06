class_name Square
extends Node2D

@export var stats: SquareStats

func action() -> void:
	get_tree().call_group("Square Manager", "action", stats.type)
