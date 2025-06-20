class_name AudioManager
extends Node

@export var move: AudioStreamPlayer

func play_move_sfx() -> void:
	move.play()
