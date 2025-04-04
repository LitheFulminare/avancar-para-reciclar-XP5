extends Node2D

# maybe make player a scene and then create a list of those scenes?
@onready var player1 = $Players/Player1
@onready var player2 = $Players/Player2
@onready var player3 = $Players/Player3

func _input(event: InputEvent) -> void:
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
		
		else:
			var player_array: Array = [player1, player2, player3]
			player_array.sort()
			print(player_array[0].dice_roll, player_array[1].dice_roll, player_array[2].dice_roll)
