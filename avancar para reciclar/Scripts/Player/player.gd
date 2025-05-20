class_name Player
extends Node

signal move(target_position: Vector2)
signal stopped_moving # connected to player_stopped_moving() on the RoundManager

@export var dice_roll: int = 0
@export var total_cards: int = 0

var trash_cards: Array[TrashCard] = []

# doesn't get changed internally
# round_manager changes right before moving the player
var current_square : int = 0
var current_branch: PathManager.branches
var next_branch_start: int

func _on_move(target_position: Vector2) -> void:
	print("moving to " + str(target_position))
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, 1)
	await tween.finished
	stopped_moving.emit() # connected to player_stopped_moving() on the RoundManager
