@tool

class_name Square
extends Node2D

@export var stats: SquareStats
@export var square_sprite: Sprite2D
@export_group("Square logic")
@export var next_square: Square
@export var is_fork: bool = false
@export var fork_number: int = 0
@export var branch_A_start: Square
@export var branch_B_start: Square

func _ready() -> void:
	if stats != null && stats.sprite != null:
		square_sprite.texture = stats.sprite

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if square_sprite != null:
			if stats != null && stats.sprite != null:
				square_sprite.texture = stats.sprite

func action() -> void:
	get_tree().call_group("Square Manager", "action", stats.type)
	
func update_size(new_size:float = 1.0) -> void:
	scale.x = new_size
	scale.y = new_size
