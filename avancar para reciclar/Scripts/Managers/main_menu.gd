extends Node2D

# maybe make player a scene and then create a list of those scenes?
var player1_number: int = 0
var player2_number: int = 0
var player3_number: int = 0

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Confirm"):
		if player1_number == 0:
			player1_number = roll_dice()
			print("player 1 rolled: " + str(player1_number))
			
		elif player2_number == 0 || player2_number == player1_number:
			player2_number = roll_dice()
			print("player 2 rolled: " + str(player2_number))
			
		elif player3_number == 0 || player3_number == player1_number || player3_number == player2_number:
			player3_number = roll_dice()
			print("player 3 rolled: " + str(player3_number))
		
		else:
			var player_array: Array = [player1_number, player2_number, player3_number]
			player_array.sort()
			print(player_array)
			
# maybe dedicate a node to handle this?
func roll_dice() -> int:
	# also put screen effects here
	return GameManager.rng.randi_range(1, 6)
