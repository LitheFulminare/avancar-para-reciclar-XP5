@tool

class_name Square
extends Node2D

@export var stats: SquareStats
@export var square_sprite: Sprite2D

func _ready() -> void:
	if stats != null && stats.sprite != null:
		square_sprite.texture = stats.sprite

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if square_sprite != null:
			if stats != null && stats.sprite != null:
				square_sprite.texture = stats.sprite

func action() -> void:
	get_tree().call_group("Square Manager", "action", stats.type)
