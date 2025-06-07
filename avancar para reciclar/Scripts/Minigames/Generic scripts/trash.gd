class_name Trash
extends Area2D

enum trash_type
{
	glass_broken_bottle,
	glass_glass,
	metal_can,
	metal_cog,
	metal_nail,
	organic_banana,
	organic_fish,
	paper_ball,
	paper_roll,
	plastic_bag,
	plastic_bottle
}

@export var type: trash_type

func apply_boat_minigame_transform() -> void:
	match type:
		trash_type.glass_broken_bottle:
			scale = Vector2(0.2, 0.2)
		trash_type.glass_glass:
			scale = Vector2(0.12, 0.12)
		trash_type.metal_can:
			scale = Vector2(0.1, 0.1)
		trash_type.metal_cog:
			scale = Vector2(0.24, 0.24)
		trash_type.metal_nail:
			scale = Vector2(0.075, 0.075)
		trash_type.organic_banana:
			scale = Vector2(0.165, 0.165)
		trash_type.organic_fish:
			scale = Vector2(0.11, 0.11)
		trash_type.paper_ball:
			scale = Vector2(0.05, 0.05)
		trash_type.paper_roll:
			scale = Vector2(0.095, 0.095)
		trash_type.plastic_bag: 
			scale = Vector2(0.19, 0.19)
		trash_type.plastic_bottle:
			scale = Vector2(0.215, 0.215)
			
	rotation_degrees = randi_range(0, 360)
