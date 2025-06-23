class_name TrashCard
extends Node

var stats: TrashCardStats
@export_group("Internal components")
@export var icon: Sprite2D
@export var background_card: Sprite2D
@export var face_up_elements: Node2D
@export var face_down_elements: Node2D

func _ready() -> void:
	face_up_elements.visible = false
	face_down_elements.visible = true

func update_stats(new_stats: TrashCardStats) -> void:
	stats = new_stats
	
	# this should ne uncommented once the BG Card sprite is completely blank
	#icon.texture = stats.get_random_sprite()
	
	background_card.texture = stats.background_card.pick_random()

func reveal() -> void:
	face_up_elements.visible = true
	face_down_elements.visible = false
