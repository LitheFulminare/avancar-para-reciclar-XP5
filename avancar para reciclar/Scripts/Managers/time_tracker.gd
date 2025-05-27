class_name TimeTracker
extends Node

static var time: float

func _process(delta: float) -> void:
	time += delta
