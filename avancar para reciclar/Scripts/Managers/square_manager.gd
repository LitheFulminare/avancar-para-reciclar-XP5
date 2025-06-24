# handles square-specific actions, like skipping next player's turn

@tool

class_name SquareManager
extends Node

enum square_type
{
	luck_card, # draws a luck card with a random action
	collect_trash, # player collects a random trash
	discard_glass, # player can discard glass
	discard_metal, # player can discard metal
	discard_organic, # player can discard organic
	discard_paper, # player can discard paper
	discard_plastic, # player can discard plastic
	garbage_truck, # player can discard any trash card
	quiz_card # draws a quiz card
}

@export var round_manager: RoundManager
@export var square_size: float = 1.0

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		get_tree().call_group("Square", "update_size", square_size)

# the square the player landed calls this method on nodes that are part of the "Round Manager" group
## maybe this functions could be their own subresource and the square type res has that subres
func action(type: square_type):
	match type:
		square_type.luck_card:
			luck_card()
		square_type.collect_trash:
			collect_trash()
		square_type.discard_glass:
			discard_trash(TrashCardStats.types.glass)
		square_type.discard_metal:
			discard_trash(TrashCardStats.types.metal)
		square_type.discard_organic:
			discard_trash(TrashCardStats.types.organic)
		square_type.discard_paper:
			discard_trash(TrashCardStats.types.paper)
		square_type.discard_plastic:
			discard_trash(TrashCardStats.types.plastic)
		square_type.garbage_truck:
			garbage_truck()
		square_type.quiz_card:
			quiz_card()
		
func luck_card() -> void:
	print("Player landed on a Luck Card square")
	round_manager.square_action_finished()

func collect_trash() -> void:
	round_manager.add_trash(round_manager.turn - 1, round_manager.get_random_trash_type())
	
func discard_trash(trash_type: TrashCardStats.types) -> void:
	print("Player landed on a Discard trash square")
	print("Parameter passed: " + str(trash_type))
	round_manager.square_action_finished()
	
func garbage_truck() -> void:
	get_tree().call_group("Discard Trash Manager", "discard_any_trash")
	#round_manager.square_action_finished()

func quiz_card():
	round_manager.draw_question_card()
