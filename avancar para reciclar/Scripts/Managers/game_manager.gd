# handles main game logic

extends Node

var player_count: int = 3 
var turn: int = 0; # goes from 1 to 2 or 3 depending on the player count
var current_round: int = 1;
var max_round: int = 20; # maybe give the player the option to ajust this?

func _ready() -> void:
	# this wont be on _ready() forever
	# a button click on the menu will call this function
	start_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Confirm"):
		next_turn();

# called at the start of the game
func start_game():
	print("Now starting round: " + str(current_round))
	next_turn()

func next_turn():
	if turn == player_count:
		current_round += 1
		turn = 1
		print("Round ended")
		print("")
		print("Now starting round: " + str(current_round))
		print("Current turn: " + str(turn))
		
	else:
		turn += 1
		print("Current turn: " + str(turn))
