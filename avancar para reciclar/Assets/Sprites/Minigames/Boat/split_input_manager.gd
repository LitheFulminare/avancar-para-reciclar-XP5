# gets the inputs and decided which boat's move_hook() method should be called

class_name BoatSplitInputManager
extends Node

@export var player1: Boat
@export var player2: Boat
@export var player3: Boat

func _process(delta: float) -> void:
	# player 1 input
	if Input.is_action_pressed("Player 1 Left"):
		player1.move_hook(Vector2(-1, 0), delta)
	if Input.is_action_pressed("Player 1 Right"):
		player1.move_hook(Vector2(1, 0), delta)
	if Input.is_action_pressed("Player 1 Up"):
		player1.move_hook(Vector2(0, -1), delta)
		
	# player 2 input
	if Input.is_action_pressed("Player 2 Left"):
		player2.move_hook(Vector2(-1, 0), delta)
	if Input.is_action_pressed("Player 2 Right"):
		player2.move_hook(Vector2(1, 0), delta)
	if Input.is_action_pressed("Player 2 Up"):
		player2.move_hook(Vector2(0, -1), delta)
	
	# player 3 input
	if Input.is_action_pressed("Player 3 Left"):
		player3.move_hook(Vector2(-1, 0), delta)
	if Input.is_action_pressed("Player 3 Right"):
		player3.move_hook(Vector2(1, 0), delta)
	if Input.is_action_pressed("Player 3 Up"):
		player3.move_hook(Vector2(0, -1), delta)
