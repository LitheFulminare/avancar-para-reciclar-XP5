class_name QuestionCard
extends Node

# set by RoundManager when being instantiated
var texts: QuestionCardTexts

var question: String
var right_answer: String
var wrong_answer_1: String
var wrong_answer_2: String

# called by round manager after being instantiated and added to the tree
func set_texts(question_texts: QuestionCardTexts) -> void:
	texts = question_texts
	
	question = texts.question
	right_answer = texts.right_answer
	wrong_answer_1 = texts.wrong_answer_1
	wrong_answer_2 = texts.wrong_answer_2
	
	print_texts()

# temporary. it's only for debug purposes
func print_texts():
	print("")
	print(question)
	print(right_answer)
	print(wrong_answer_1)
	print(wrong_answer_2)
