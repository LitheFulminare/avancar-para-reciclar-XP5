class_name Dice
extends Node2D

signal dice_landed
signal second_dice_landed

@export var animated_sprite: AnimatedSprite2D
@export var sprite: Sprite2D

@export var dice1: Texture2D
@export var dice2: Texture2D
@export var dice3: Texture2D
@export var dice4: Texture2D
@export var dice5: Texture2D
@export var dice6: Texture2D

var dice_result: int
var is_first_dice_roll: bool

func roll_dice(result: int, is_first_roll: bool) -> void:
	is_first_dice_roll = is_first_roll
	dice_result = result
	animated_sprite.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite.visible = false
	
	match dice_result:
		1:
			sprite.texture = dice1
		2:
			sprite.texture = dice2
		3:
			sprite.texture = dice3
		4:
			sprite.texture = dice4
		5: 
			sprite.texture = dice5
		6:
			sprite.texture = dice6
	
	dice_landed.emit()
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.5)
	
	await tween.finished
	if !is_first_dice_roll:
		second_dice_landed.emit()
	queue_free()
