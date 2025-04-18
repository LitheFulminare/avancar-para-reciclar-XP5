extends Node

signal move(target_position: Vector2)

@export var dice_roll: int = 0
@export var total_cards: int = 0


func _on_move(target_position: Vector2) -> void:
		print("moving to " + str(target_position))
		var tween = create_tween()
		tween.tween_property(self, "position", target_position, 1)
