class_name LabelManager
extends Label

var original_height: float

func _ready() -> void:
	original_height = size.y
	print("original height: " + str(original_height))

func update_text(new_text: String) -> void:
	text = new_text
	#var new_size: float 
	print("new size: " + str(size.y))
	if size.y > original_height:
		print("original height exceeded")
	else: 
		print("original height was not exceeded")
