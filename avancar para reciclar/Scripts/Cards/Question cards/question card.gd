class_name QuestionCard
extends Node

# set by RoundManager when being instantiated
var texts: QuestionCardTexts

@export var question_text_label: Label

# called by round manager after being instantiated and added to the tree
func set_texts(question_texts: QuestionCardTexts) -> void:
	texts = question_texts
	question_text_label.text = texts.question
	
	print_texts()

# temporary. it's only for debug purposes
func print_texts():
	print("")
	print(texts.question)
	print(texts.right_answer)
	print(texts.wrong_answer_1)
	print(texts.wrong_answer_2)
	print(texts.wrong_answer_3)
