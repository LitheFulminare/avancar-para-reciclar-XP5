class_name TrashCard
extends Node

var stats: TrashCardStats
@export var icon: Sprite2D
@export var background_card: Sprite2D

func update_stats(new_stats: TrashCardStats) -> void:
	stats = new_stats
	
	# this should ne uncommented once the BG Card sprite is completely blank
	#icon.texture = stats.get_random_sprite()
	
	background_card.texture = stats.background_card
