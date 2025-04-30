class_name Square
extends Node2D

var stats: SquareStats

func action() -> void:
	# gets what type of square is this and calls the corresponding function
	## maybe these functions could be in a subresource assigned to the resources,
	## but i'm too lazy for that
	match stats.type:
		RoundManager.square_type.luck_card:
			luck_card()
		RoundManager.square_type.collect_trash:
			collect_trash()
		RoundManager.square_type.discard_trash:
			discard_trash()
		RoundManager.square_type.garbage_truck:
			garbage_truck()
		RoundManager.square_type.quiz_card:
			quiz_card()
		
func luck_card() -> void:
	return

func collect_trash() -> void:
	return
	
func discard_trash() -> void:
	return
	
func garbage_truck() -> void:
	return
	
func quiz_card() -> void:
	return
