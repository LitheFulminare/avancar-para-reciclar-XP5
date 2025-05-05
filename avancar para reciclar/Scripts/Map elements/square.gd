class_name Square
extends Node2D

var stats: SquareStats

static var round_manager: RoundManager

func action() -> void:
	get_tree().call_group("Square Manager", "action", stats.type)
