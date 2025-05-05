# handles square-specific actions, like skipping next player's turn

class_name SquareManager
extends Node

enum square_type
{
	luck_card,
	collect_trash,
	discard_trash,
	garbage_truck,
	quiz_card
}

@export var round_manager: RoundManager

# the square the player landed calls this method on nodes that are part of the "Round Manager" group
## maybe this functions could be their own subresource and the square type res has that subres
func action(type: square_type):
	match type:
		square_type.luck_card:
			luck_card()
		square_type.collect_trash:
			collect_trash()
		square_type.discard_trash:
			discard_trash()
		square_type.garbage_truck:
			garbage_truck()
		square_type.quiz_card:
			quiz_card()
		
func luck_card() -> void:
	return

func collect_trash() -> void:
	round_manager.add_trash(round_manager.turn - 1, round_manager.get_random_trash_type())
	
func discard_trash() -> void:
	return
	
func garbage_truck() -> void:
	return
	
func quiz_card() -> void:
	return
	
