class_name DiscardTrashManager
extends Node

@export var round_manager: RoundManager
@export var discard_trash_scene: PackedScene

var discard_trash: DiscardTrash

var discarded_card: TrashCard

func _ready() -> void:
	discard_trash = discard_trash_scene.instantiate()
	add_child(discard_trash)
	discard_trash.visible = false
	
	connect_signals()

func connect_signals() -> void:
	discard_trash.glass_button_pressed.connect(_on_glass_pressed)
	discard_trash.metal_button_pressed.connect(_on_metal_pressed)
	discard_trash.organic_button_pressed.connect(_on_organic_pressed)
	discard_trash.paper_button_pressed.connect(_on_paper_pressed)
	discard_trash.plastic_button_pressed.connect(_on_plastic_pressed)

func action_finished() -> void:
	discard_trash.visible = false
	
	var screen_mid_point: Vector2 = Vector2(get_viewport().get_visible_rect().size.x/2, 
	get_viewport().get_visible_rect().size.y/2)
	
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(discarded_card, "scale", Vector2(1.5, 1.5), 0.6)
	tween.tween_property(discarded_card, "global_position", screen_mid_point, 0.6)
	await tween.finished
	
	await get_tree().create_timer(0.6).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(discarded_card, "modulate:a", 0, 0.6)
	
	await tween.finished
	discarded_card.queue_free()
	#round_manager.square_action_finished()

#region Garbage truck and buttons logic

func discard_any_trash() -> void:
	discard_trash.visible = true

func _on_glass_pressed() -> void:
	if round_manager.active_player.glass_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		return
	
	round_manager.active_player.points += round_manager.active_player.glass_trash_cards[0].stats.value
	discarded_card = round_manager.active_player.glass_trash_cards[0]
	round_manager.active_player.glass_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.glass)
	round_manager.active_player.points_changed.emit()
	
	action_finished()

func _on_metal_pressed() -> void:
	if round_manager.active_player.metal_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		return
	
	round_manager.active_player.points += round_manager.active_player.metal_trash_cards[0].stats.value
	discarded_card = round_manager.active_player.metal_trash_cards[0]
	round_manager.active_player.metal_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.metal)
	round_manager.active_player.points_changed.emit()
	
	action_finished()
	
func _on_organic_pressed() -> void:
	if round_manager.active_player.organic_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		return
	
	round_manager.active_player.points += round_manager.active_player.organic_trash_cards[0].stats.value
	discarded_card = round_manager.active_player.organic_trash_cards[0]
	round_manager.active_player.organic_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.organic)
	round_manager.active_player.points_changed.emit()
	
	action_finished()
	
func _on_paper_pressed() -> void:
	if round_manager.active_player.paper_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		return
	
	round_manager.active_player.points += round_manager.active_player.paper_trash_cards[0].stats.value
	discarded_card = round_manager.active_player.paper_trash_cards[0]
	round_manager.active_player.paper_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.paper)
	round_manager.active_player.points_changed.emit()
	
	action_finished()
	
func _on_plastic_pressed() -> void:
	if round_manager.active_player.plastic_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		return
	
	round_manager.active_player.points += round_manager.active_player.plastic_trash_cards[0].stats.value
	discarded_card = round_manager.active_player.plastic_trash_cards[0]
	round_manager.active_player.plastic_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.plastic)
	round_manager.active_player.points_changed.emit()
	
	action_finished()
	
#endregion
