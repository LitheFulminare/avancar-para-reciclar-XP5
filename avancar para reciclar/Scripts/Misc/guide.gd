class_name Guide
extends Node2D

@export var guide_elements: Control
@export var show_guide_button: TextureButton

func _ready() -> void:
	guide_elements.visible = false

func _on_continue_button_pressed() -> void:
	guide_elements.visible = false
	show_guide_button.visible = true

func _on_show_guide_button_pressed() -> void:
	show_guide_button.visible = false
	guide_elements.visible = true
