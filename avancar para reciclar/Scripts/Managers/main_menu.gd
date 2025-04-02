extends Node2D

var player1_number: int
var player2_number: int
var player3_number: int

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
		#player1_number = roll_dice()
		
# maybe dedicate a node to handle this?
func roll_dice() -> int:
	# also put screen effects here
	return GameManager.rng.randi_range(1, 6)
