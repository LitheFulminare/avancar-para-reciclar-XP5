class_name DiscardTrash
extends Node2D

signal glass_button_pressed
signal metal_button_pressed
signal organic_button_pressed
signal paper_button_pressed
signal plastic_button_pressed

@export var warning_label: Label

func _ready() -> void:
	warning_label.modulate.a = 0

func _process(_delta: float) -> void:
	# for debug
	if Input.is_key_pressed(KEY_1):
		spawn_no_trash_warning()

func spawn_no_trash_warning() -> void:
	if warning_label.modulate.a == 0:
		warning_label.modulate.a = 1
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(warning_label, "modulate:a", 0, 5)


func _on_glass_pressed() -> void:
	glass_button_pressed.emit()

func _on_metal_pressed() -> void:
	metal_button_pressed.emit()

func _on_organic_pressed() -> void:
	organic_button_pressed.emit()

func _on_paper_pressed() -> void:
	paper_button_pressed.emit()

func _on_plastic_pressed() -> void:
	plastic_button_pressed.emit()
