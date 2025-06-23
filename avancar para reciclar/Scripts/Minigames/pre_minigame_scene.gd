class_name PreMinigameScene
extends Node2D

@export_group("Minigames")
@export var minigames: Array[String]

func _on_continue_button_pressed() -> void:
	GameManager.go_to_scene(minigames.pick_random())
