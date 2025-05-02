class_name Square
extends Node2D

var stats: SquareStats

func action() -> void:
	SquareManager.action(stats.type)
