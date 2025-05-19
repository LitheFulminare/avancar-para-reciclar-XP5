#@tool

class_name Square
extends Node2D

@export var stats: SquareStats

#func _process(delta: float) -> void:
	#if Engine.is_editor_hint():
		#return

func action() -> void:
	get_tree().call_group("Square Manager", "action", stats.type)
