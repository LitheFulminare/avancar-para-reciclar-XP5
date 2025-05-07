# loads and keeps track of the text resources to display on the question cards

class_name QuestionCardResourceManager
extends Node

const res_directory_path: String = "res://Resources/Cards/Question Cards/"
var question_card_texts: Array[QuestionCardTexts]
var unpicked_question_cards: Array[QuestionCardTexts] # used to avoid repeating questions

func _ready() -> void:
	# gets all the files in the "Question Cards" folder, loads them and adds them to the array
	var res_directory: PackedStringArray = ResourceLoader.list_directory(res_directory_path)
		
	for res in res_directory:
		question_card_texts.append(load(res_directory_path+res))
		
	# used to avoid repeating questions
	unpicked_question_cards = question_card_texts.duplicate()

func get_random_question_res() -> QuestionCardTexts:
	if unpicked_question_cards.size() == 0:
		unpicked_question_cards = question_card_texts.duplicate()
	
	randomize()
	var random_index = randi_range(0, unpicked_question_cards.size() - 1)
	
	var picked_question: QuestionCardTexts = unpicked_question_cards[random_index]
	unpicked_question_cards.remove_at(random_index)
	
	return picked_question
