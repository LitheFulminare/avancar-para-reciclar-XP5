class_name QuestionCard
extends Node

# unsure if it's going to be exposed to the editor to asign manually or
# make an array, preload everything and randomize 1 (I think this option is better)
#@export var texts: QuestionCardTexts
var texts: QuestionCardTexts

var question: String
var right_answer: String
var wrong_answer_1: String
var wrong_answer_2: String

func _ready() -> void:
	question = texts.question
	right_answer = texts.right_answer
	wrong_answer_1 = texts.wrong_answer_1
	wrong_answer_2 = texts.wrong_answer_2
