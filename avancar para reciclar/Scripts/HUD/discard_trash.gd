class_name DiscardTrash
extends Node2D

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
