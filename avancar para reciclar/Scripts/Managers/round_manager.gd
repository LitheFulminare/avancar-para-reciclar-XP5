# handles core game loop

extends Node

enum round_states {start_round, first_dice_roll, second_dice_roll, move, end_round}
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
	next_turn()

func next_turn():
	action()

# gets the current round state and decides what to do
# note:  I could change tje current round and call action again to be recursive, 
# but all action would happen at once, which is not what I want.
func action():
	match current_round_state:
		round_states.start_round:
			print("Current round: " + str(GameManager.current_round))
			
		
		round_states.first_dice_roll: 
			return
		round_states.second_dice_roll: 
			return
		
		round_states.move: 
			return
			
		round_states.end_round:
			return
