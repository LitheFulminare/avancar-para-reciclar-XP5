# loads and keeps track of the text resources to display on the question cards

class_name QuestionCardResourceManager
extends Node

const res_directory_path: String = "res://Resources/Cards/Question Cards/"
var question_card_texts: Array[QuestionCardTexts]

func _ready() -> void:
	var res_directory = ResourceLoader.list_directory(res_directory_path)
		
	for res in res_directory:
		question_card_texts.append(load(res_directory_path+res))
