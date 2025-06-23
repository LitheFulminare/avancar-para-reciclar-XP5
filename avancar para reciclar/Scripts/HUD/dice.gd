class_name Dice
extends Node2D

@export var animated_sprite: AnimatedSprite2D

var dice_result: int

func roll_dice(result: int) -> void:
	dice_result = result
	animated_sprite.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	match dice_result:
		1:
			return
		2:
			return
		3:
			return
		4:
			return
		5: 
			return
		6:
			return
