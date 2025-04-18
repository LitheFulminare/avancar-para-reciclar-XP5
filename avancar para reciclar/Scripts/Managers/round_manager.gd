# handles core game loop

extends Node

enum round_states { start_round, 
					start_turn, 
					first_dice_roll, 
					second_dice_roll, 
					move, end_turn, 
					end_round }

var current_round_state: round_states = round_states.start_round

var turn: int = 0 # goes from 1 to 2 or 3 depending on the player count
var current_round: int = 1

var first_dice_result: int = 0
var second_dice_result: int = 0
var total_dice_result: int = 0

var active_player : Node2D

@onready var player1 = $"../Players/Player 1"
@onready var player2 = $"../Players/Player 2"
@onready var player3 = $"../Players/Player 3"

@onready var player_array : Array[Node] = $"../Players".get_children()
@onready var square_array : Array[Node] = $"../Squares".get_children()

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
# note:  I could change the current round and call action again to be recursive, 
# but all action would happen at once, which is not what I want.
func action():
	match current_round_state:
		round_states.start_round:
			print("Starting round: " + str(current_round))
			turn = 0
			current_round_state = round_states.start_turn
		
		round_states.start_turn:
			turn += 1
			active_player = player_array[turn-1]
			print(active_player.name + "'s turn")
			current_round_state = round_states.first_dice_roll
		
		round_states.first_dice_roll: 
			first_dice_result = GameManager.roll_dice(1, 6)
			print("First dice roll: " + str(first_dice_result))
			current_round_state = round_states.second_dice_roll
			
		round_states.second_dice_roll: 
			second_dice_result = GameManager.roll_dice(1, 6)
			total_dice_result = first_dice_result + second_dice_result
			print("Second dice roll: " + str(second_dice_result))
			# if there is a special item that makes the player roll another dice I could 
			# add another state here
			current_round_state = round_states.move
		
		round_states.move: 
			move()
			current_round_state = round_states.end_turn
			
		round_states.end_turn:
			if turn == GameManager.player_count:
				# maybe I could change the state (like I'm doing already) and calling aciont() again
				# then it automatically triggers the end of the round
				print("Last turn ended. Press again to finish the round")
				current_round_state = round_states.end_round
			else:
				print("Turn ended")
				print("")
				current_round_state = round_states.start_turn
			
		round_states.end_round:
			print("Round ended")
			print("")
			current_round += 1
			current_round_state = round_states.start_round

func move():
	active_player.current_square += total_dice_result
	#active_player.emit_signal("move", total_dice_result)
	active_player.emit_signal("move", square_array[active_player.current_square-1].global_position)
