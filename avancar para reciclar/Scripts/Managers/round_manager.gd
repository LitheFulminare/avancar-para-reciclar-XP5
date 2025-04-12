# handles core game loop

extends Node

enum round_states {first_dice_roll, second_dice_roll, move}
var current_round_state: round_states = round_states.first_dice_roll

func _ready() -> void:
	# this wont be on _ready() forever
	# a button click on the menu will call this function
	start_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Confirm"):
		next_turn();

# called at the start of the game
func start_game():
	print("Now starting round: " + str(GameManager.current_round))
	next_turn()

func next_turn():
	if GameManager.turn == GameManager.player_count: # when the last player finished their turn
		
		current_round_state = round_states.move
		
		GameManager.current_round += 1
		GameManager.turn = 1
		print("Round ended")
		print("")
		print("Now starting round: " + str(GameManager.current_round))
		
	else: # when there still players left to play on the round
		GameManager.turn += 1
		
	var dice_number: int = GameManager.roll_dice(1, 6)
	print("Current turn: " + str(GameManager.turn))
	print("Dice rolled, player got a " + str(dice_number))

# gets the current round state and decides what to do
func action():
	match current_round_state:
		round_states.first_dice_roll: return
		round_states.second_dice_roll: return
		round_states.move: return
