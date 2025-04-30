class_name Square
extends Node2D

var stats: SquareStats

func action() -> void:
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
