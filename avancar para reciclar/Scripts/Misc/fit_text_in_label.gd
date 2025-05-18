class_name LabelManager
extends Label

var font_theme: Theme = preload("res://Misc/Text/Question card text theme.tres")

var original_height: float

func _ready() -> void:
	original_height = size.y
	print("original height: " + str(original_height))
	
func update_text(new_text: String) -> void:
	text = new_text
	
func _on_resized() -> void:
	print("new size: " + str(size.y))
	while size.y > original_height:
		add_theme_font_size_override("font_size", get_theme_font_size("font_size")-1)
		print("new font size: " + str(get_theme_font_size("font_size")-1))
		print("size after decrease: " + str(size.y))
		#print(get_theme_font_size("Question card text theme"))
