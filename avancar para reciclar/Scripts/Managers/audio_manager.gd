class_name AudioManager
extends Node

@export_group("SFX")
@export var move: AudioStreamPlayer
@export var rolling_dice: AudioStreamPlayer
@export var select: AudioStreamPlayer
@export var trash_collected: AudioStreamPlayer

@export_group("OST")
@export var boat_minigame_ost: AudioStreamPlayer
@export var question_card_ost: AudioStreamPlayer
@export var gameplay_ost: AudioStreamPlayer
@export var victory_ost: AudioStreamPlayer

func get_random_pitch() -> float:
	randomize()
	return randf_range(0.80, 1.2)

func play_move_sfx() -> void:
	move.play()
	move.pitch_scale = get_random_pitch()
	
func play_rolling_dice_SFX() -> void:
	rolling_dice.play()
	rolling_dice.pitch_scale = get_random_pitch()
	
func play_trash_collected_sfx() -> void:
	trash_collected.play()
	trash_collected.pitch_scale = get_random_pitch()

func play_question_card_ost() -> void:
	question_card_ost.play()
	
func stop_question_card_ost() -> void:
	question_card_ost.stop()
	
func play_boat_minigame_ost() -> void:
	boat_minigame_ost.play()
	
func stop_boat_minigame_ost() -> void:
	boat_minigame_ost.stop()
	
func play_victory_ost() -> void:
	victory_ost.play()
	gameplay_ost.stop()
