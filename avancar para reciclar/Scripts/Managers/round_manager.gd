# handles core game loop

extends Node

func _ready() -> void:
	# this wont be on _ready() forever
	# a button click on the menu will call this function
	GameManager.rng.randomize()
	start_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Confirm"):
		next_turn();

# called at the start of the game
func start_game():
	print("Now starting round: " + str(GameManager.current_round))
	next_turn()

func next_turn():
	if GameManager.turn == GameManager.player_count:
		GameManager.current_round += 1
		GameManager.turn = 1
		print("Round ended")
		print("")
		print("Now starting round: " + str(GameManager.current_round))
		#print("Current turn: " + str(GameManager.turn))
		
	else:
		GameManager.turn += 1
		
	var dice_number: int = GameManager.roll_dice(1, 6)
	print("Current turn: " + str(GameManager.turn))
	print("Dice rolled, player got a " + str(dice_number))
