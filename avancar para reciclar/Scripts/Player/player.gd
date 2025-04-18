extends Node

signal move(distance: int)

@export var dice_roll: int = 0
@export var total_cards: int = 0


func _on_move(distance: int) -> void:
		print("Moving " + str(distance) + " squares")
