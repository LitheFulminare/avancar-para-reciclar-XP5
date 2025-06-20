class_name AudioManager
extends Node

@export var move: AudioStreamPlayer
@export var rolling_dice: AudioStreamPlayer

func get_random_pitch() -> float:
	randomize()
	return randf_range(0.9, 1.1)

func play_move_sfx() -> void:
	move.play()
	move.pitch_scale = get_random_pitch()
	
func play_rolling_dice_SFX() -> void:
	rolling_dice.play()
	rolling_dice.pitch_scale = get_random_pitch()
