class_name QuestionCard
extends Node

# set by RoundManager when being instantiated
var texts: QuestionCardTexts

@export var question_text_label: Label
@export var face_up_elements: Node2D
@export var face_down_elements: Node2D

func _ready() -> void:
	face_up_elements.visible = false
	face_down_elements.visible = true

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

func reveal() -> void:
	face_up_elements.visible = true
	face_down_elements.visible = false
