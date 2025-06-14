class_name TrashCard
extends Node

var stats: TrashCardStats
@export var sprite: Sprite2D

func update_stats(new_stats: TrashCardStats) -> void:
	stats = new_stats
	sprite.texture = stats.get_random_sprite()
