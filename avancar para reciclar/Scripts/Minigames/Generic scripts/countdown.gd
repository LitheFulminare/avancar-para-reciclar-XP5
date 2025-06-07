class_name Countdown
extends Control

signal countdown_ended

@export var countdown_text: Label

func change_text(new_text: String, grow_with_tween: bool) -> void:
	if grow_with_tween:
		countdown_text.scale = Vector2.ZERO
		tween_label_scale()
		
	countdown_text.text = new_text

# called by the minigame manager on start
func start_countdown() -> void:
	countdown_text.scale = Vector2.ZERO
	
	await get_tree().create_timer(1).timeout
	tween_label_scale()
	countdown_text.text = "3"
	
	await get_tree().create_timer(0.7).timeout
	countdown_text.text = ""
	countdown_text.scale = Vector2.ZERO
	
	await get_tree().create_timer(0.3).timeout
	tween_label_scale()
	countdown_text.text = "2"
	
	await get_tree().create_timer(0.7).timeout
	countdown_text.text = ""
	countdown_text.scale = Vector2.ZERO
	
	await get_tree().create_timer(0.3).timeout
	tween_label_scale()
	countdown_text.text = "1"
	
	await get_tree().create_timer(0.7).timeout
	countdown_text.text = ""
	countdown_text.scale = Vector2.ZERO
	
	await get_tree().create_timer(0.3).timeout
	tween_label_scale()
	countdown_text.text = "Já!"
	
	await get_tree().create_timer(0.7).timeout
	countdown_text.text = ""
	countdown_text.scale = Vector2(1, 1)
	
	await get_tree().create_timer(0.3).timeout
	
	countdown_ended.emit()
	
func tween_label_scale() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(countdown_text, "scale", Vector2(1, 1), 0.15)
