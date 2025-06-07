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
	countdown_text.text = "3"
	tween_label_scale()
	
	await get_tree().create_timer(0.7).timeout
	countdown_text.scale = Vector2.ZERO
	countdown_text.text = ""
	
	await get_tree().create_timer(0.3).timeout
	countdown_text.text = "2"
	tween_label_scale()
	
	await get_tree().create_timer(0.7).timeout
	countdown_text.scale = Vector2.ZERO
	countdown_text.text = ""
	
	await get_tree().create_timer(0.3).timeout
	countdown_text.text = "1"
	tween_label_scale()
	
	await get_tree().create_timer(0.7).timeout
	countdown_text.scale = Vector2.ZERO
	countdown_text.text = ""
	
	await get_tree().create_timer(0.3).timeout
	countdown_text.text = "Já!"
	tween_label_scale()
	
	await get_tree().create_timer(0.7).timeout
	countdown_text.scale = Vector2(1, 1)
	countdown_text.text = ""
	
	await get_tree().create_timer(0.3).timeout
	
	countdown_ended.emit()
	
func tween_label_scale() -> void:
	# wait for the label size to be changed before updating the pivot offset
	await get_tree().process_frame
	
	update_offset()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(countdown_text, "scale", Vector2(1, 1), 0.15)

func update_offset() -> void:
	countdown_text.pivot_offset.x = countdown_text.size.x / 2
	countdown_text.pivot_offset.y = countdown_text.size.y / 2
