class_name ScoreDisplay
extends Node2D

@onready var label: Label = $Label

func update_score(new_score: String) -> void:
	label.text = new_score
