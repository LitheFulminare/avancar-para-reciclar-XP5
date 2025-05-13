class_name QuestionCard
extends Node

# set by RoundManager when being instantiated
var texts: QuestionCardTexts

@export_group("Elements")
@export var face_up_elements: Node2D
@export var face_down_elements: Node2D

@export_group("Texts")
@export var question_text_label: Label
@export var answer1_button: Button
@export var answer2_button: Button
@export var answer3_button: Button
@export var answer4_button: Button

@onready var answer_buttons: Array[Button] = [answer1_button, answer2_button, answer3_button, answer4_button]
var right_answer_index: int = 0

var answers: Array[String]

func _ready() -> void:
	face_up_elements.visible = false
	face_down_elements.visible = true

# called by round manager after being instantiated and added to the tree
func set_texts(question_texts: QuestionCardTexts) -> void:
	if question_texts == null:
		printerr("question texts is null")
		get_tree().paused = true
	
	texts = question_texts
	answers = [texts.wrong_answer_1, texts.wrong_answer_2, texts.wrong_answer_3]
	
	question_text_label.text = texts.question
	
	randomize()
	right_answer_index = randi_range(0, answer_buttons.size()-1)
	print("right answer index: " + str(right_answer_index))
	answer_buttons[right_answer_index].text = texts.right_answer
	answer_buttons.remove_at(right_answer_index)
	
	for i in range(answer_buttons.size()):
		answer_buttons[i-1].text = get_random_wrong_answer()
		answer_buttons.remove_at(i-1)

func reveal() -> void:
	face_up_elements.visible = true
	face_down_elements.visible = false

func get_random_wrong_answer() -> String:
	var rand_ans: String
	
	randomize()
	var rand_ans_index: int = randi_range(0, answers.size() - 1)
	rand_ans = answers[rand_ans_index]
	answers.remove_at(rand_ans_index)
	
	return rand_ans
