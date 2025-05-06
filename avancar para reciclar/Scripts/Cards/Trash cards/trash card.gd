class_name TrashCard
extends Node

var stats: TrashCardStats
@export var sprite: Sprite2D

func _ready() -> void:
	sprite.image = stats.sprite
