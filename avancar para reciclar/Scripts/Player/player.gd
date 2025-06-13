class_name Player
extends Node2D

signal stopped_moving # connected to player_stopped_moving() on the RoundManager

@export var dice_roll: int = 0
@export var total_cards: int = 0
@export var speed: float = 50

var trash_cards: Array[TrashCard] = []

# doesn't get changed internally
# RoundManager changes right before moving the player
# represents the actual number of the square, and not its index on the array
var current_square: int = 0
var square: Square

var target_position: Vector2
var distance_to_target: float
var tween_duration: float

# branch variables
# again, RoundManager uses these
var current_branch: PathManager.branches
var is_at_branch_B: bool = false
var current_branch_end: int
var opposite_branch_length: int
var next_branch_start: int

func move_to_current_square() -> void:
	print("moving to " + str(square.name))
	
	distance_to_target = global_position.distance_to(square.global_position)
	tween_duration = distance_to_target / speed
	
	var tween = create_tween()
	tween.tween_property(self, "position", square.global_position, tween_duration)
	await tween.finished
	stopped_moving.emit() # connected to player_stopped_moving() on the RoundManager
