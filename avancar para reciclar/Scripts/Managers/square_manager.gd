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

# gets called by a square and makes its action
## maybe this functions could be their own subresource and the square type res has that subres
static func action(type: square_type):
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
		
static func luck_card() -> void:
	return

static func collect_trash() -> void:
	return
	
static func discard_trash() -> void:
	return
	
static func garbage_truck() -> void:
	return
	
static func quiz_card() -> void:
	return
	
