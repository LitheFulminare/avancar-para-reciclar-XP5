class_name QuestionCard
extends Node

# set by RoundManager when being instantiated
var texts: QuestionCardTexts

@export_group("Elements")
@export var face_up_elements: Node2D
@export var face_down_elements: Node2D

@export_group("Texts")
@export var question_text_label: LabelManager
@export var answer1_button: Button
@export var answer2_button: Button
@export var answer3_button: Button
@export var answer4_button: Button

@export_group("Answer feedback")
@export var answer_result: Label

# remains unaltered, it's used to know if the player clicked on the right button
@onready var base_answer_buttons: Array[Button] = [answer1_button, answer2_button, answer3_button, answer4_button]

# will have elements removed to set random texts in the buttons
@onready var answer_buttons: Array[Button] = [answer1_button, answer2_button, answer3_button, answer4_button]

var right_answer_index: int = 0

# set on ready() since the resource has to be loaded
var wrong_answers: Array[String]

const right_color: Color = Color(0.35, 0.41, 0, 1) # green
const wrong_color: Color = Color(0.875, 0, 0, 1) # red

func _ready() -> void:
	#answer_result.size = Vector2.ZERO
	answer_result.visible = false
	
	face_up_elements.visible = false
	face_down_elements.visible = true

# called by round manager after being instantiated and added to the tree
func set_texts(question_texts: QuestionCardTexts) -> void:
	if question_texts == null:
		#printerr("question texts is null")
		get_tree().paused = true
	
	texts = question_texts
	wrong_answers = [texts.wrong_answer_1, texts.wrong_answer_2, texts.wrong_answer_3]
	#print("wrong answers array size: " + str(wrong_answers.size()))
	
	question_text_label.update_text(texts.question)
	
	# sets the right answer to a random button
	randomize()
	right_answer_index = randi_range(0, answer_buttons.size()-1)
	answer_buttons[right_answer_index].text = texts.right_answer
	#print("right answer index: " + str(right_answer_index))
	
	answer_buttons[right_answer_index].add_theme_color_override("font_disabled_color", right_color)
	answer_buttons.remove_at(right_answer_index)
		
	## the i is for debug purposes only, it can be deleted
	var _i: int = 0
	
	# randomizes the wrong answers
	while answer_buttons.size() > 0:
		_i += 1
		#print("iteration " + str(i))
		answer_buttons[0].text = get_random_wrong_answer()
		#print("answer button text: " + answer_buttons[0].text)
		answer_buttons.remove_at(0)
		#print("remaining buttons: " + str(answer_buttons.size()))

func reveal() -> void:
	face_up_elements.visible = true
	face_down_elements.visible = false

# gets a random wrong answer and removes it from the array
func get_random_wrong_answer() -> String:
	var rand_ans: String
	
	randomize()
	var rand_ans_index: int = randi_range(0, wrong_answers.size() - 1)
	rand_ans = wrong_answers[rand_ans_index]
	wrong_answers.remove_at(rand_ans_index)
	
	return rand_ans

# called when player presses a button
func check_answer(button_index: int) -> void:
	spawn_answer_result(button_index == right_answer_index)
	
	disable_buttons()
		
	await get_tree().create_timer(2).timeout
	queue_free()

# spawns a text above the card telling the result
# will also do some eye candy stuff
func spawn_answer_result(player_got_right: bool):
	if !player_got_right:
		answer_result.text = "Errado"
		answer_result.add_theme_color_override("font_outline_color", wrong_color)
		
	make_label_grow(answer_result, Vector2(1, 1))

func make_label_grow(target_node: Label, target_size: Vector2) -> void:
	await get_tree().process_frame
	
	target_node.pivot_offset.x = target_node.size.x / 2
	target_node.pivot_offset.y = target_node.size.y / 2
	
	target_node.scale = Vector2.ZERO
	answer_result.visible = true
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(target_node, "scale", target_size, 0.2)

func disable_buttons() -> void:
	answer1_button.disabled = true
	answer2_button.disabled = true
	answer3_button.disabled = true
	answer4_button.disabled = true

func _on_answer_1_pressed() -> void:
	print("Button 1 pressed")
	check_answer(0)

func _on_answer_2_pressed() -> void:
	print("Button 2 pressed")
	check_answer(1)

func _on_answer_3_pressed() -> void:
	print("Button 3 pressed")
	check_answer(2)

func _on_answer_4_pressed() -> void:
	print("Button 4 pressed")
	check_answer(3)
