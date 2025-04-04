# handles main menu logic, like player rolling the dice to decide the order

extends Node2D

@onready var player1 = $Players/Player1
@onready var player2 = $Players/Player2
@onready var player3 = $Players/Player3
@onready var player_array: Array = [player1, player2, player3]

func _input(event: InputEvent) -> void:
	
	# dedicate a function to this
	if Input.is_action_just_pressed("Confirm"):
		if player1.dice_roll == 0:
			player1.dice_roll = GameManager.roll_dice(1,6)
			print("player 1 rolled: " + str(player1.dice_roll))
			
		elif player2.dice_roll == 0 || player2.dice_roll == player1.dice_roll:
			player2.dice_roll = GameManager.roll_dice(1,6)
			print("player 2 rolled: " + str(player2.dice_roll))
			
		elif player3.dice_roll == 0 || player3.dice_roll == player1.dice_roll || player3.dice_roll == player2.dice_roll:
			player3.dice_roll = GameManager.roll_dice(1,6)
			print("player 3 rolled: " + str(player3.dice_roll))
		
		else: # when every player rolled a unique number
			  # dedicate a function to this	
			var iteration: int = 0
			
			# sort player array base on dice roll (ascending)
			var in_order: bool = false
			while !in_order:
				iteration += 1
				
				var temp_player
				# check if it's in order
				if player_array[0].dice_roll > player_array[1].dice_roll:
					if player_array[1].dice_roll > player_array[2].dice_roll:
						in_order = true
					else: # when player 3 is higher than player 2
						temp_player = player_array[1]
						player_array[1] = player_array[2]
						player_array[2] = temp_player
				else: # when player 2 is higher than 1
					temp_player = player_array[0]
					player_array[0] = player_array[1]
					player_array[1] = temp_player
				
				print("Iteration " + str(iteration))
			
			print(player_array[0].dice_roll, player_array[1].dice_roll, player_array[2].dice_roll)
