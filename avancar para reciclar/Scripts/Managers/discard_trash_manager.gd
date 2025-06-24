class_name DiscardTrashManager
extends Node

@export var round_manager: RoundManager
@export var point_text: Label
@export var no_trash_warning_label: Label
@export var discard_trash_scene: PackedScene

var discard_trash: DiscardTrash

var discarded_card: TrashCard

var trash_value: int

var is_garbage_truck_square: bool

func _ready() -> void:
	discard_trash = discard_trash_scene.instantiate()
	add_child(discard_trash)
	discard_trash.visible = false
	
	point_text.visible = false
	no_trash_warning_label.visible = false
	
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
	
	round_manager.active_player.points_changed.emit()
	
	if trash_value == 1:
		point_text.text = "+ 1 ponto"
	else:
		point_text.text = "+ " + str(trash_value) + " pontos"
	point_text.visible = true
	
	await get_tree().create_timer(1).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(point_text, "scale", Vector2.ZERO, 0.25)
	
	await tween.finished
	
	point_text.visible = false
	point_text.scale = Vector2(1, 1)
	trash_value = 0
	
	is_garbage_truck_square = false
	round_manager.square_action_finished()

#region Discard square logic

func call_discard_function(trash_type: TrashCardStats.types) -> void:
	match trash_type:
		TrashCardStats.types.glass:
			_on_glass_pressed()
		TrashCardStats.types.metal:
			_on_metal_pressed()
		TrashCardStats.types.organic:
			_on_organic_pressed()
		TrashCardStats.types.paper:
			_on_paper_pressed()
		TrashCardStats.types.plastic:
			_on_plastic_pressed()

func spawn_no_trash_warning(): 
	if is_garbage_truck_square:
		return
		
	no_trash_warning_label.visible = true
	
	await get_tree().create_timer(1.25).timeout
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(no_trash_warning_label, "scale", Vector2.ZERO, 0.25)
	
	await tween.finished
	
	no_trash_warning_label.visible = false
	no_trash_warning_label.scale = Vector2(1, 1)
	
	round_manager.square_action_finished()

#endregion

#region Garbage truck and buttons logic

func discard_any_trash() -> void:
	is_garbage_truck_square = true
	discard_trash.visible = true

func _on_glass_pressed() -> void:
	if round_manager.active_player.glass_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		spawn_no_trash_warning()
		return
	
	trash_value = round_manager.active_player.glass_trash_cards[0].stats.value
	
	round_manager.active_player.points += round_manager.active_player.glass_trash_cards[0].stats.value
	discarded_card = round_manager.active_player.glass_trash_cards[0]
	round_manager.active_player.glass_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.glass)
	
	action_finished()

func _on_metal_pressed() -> void:
	if round_manager.active_player.metal_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		spawn_no_trash_warning()
		return
	
	trash_value = round_manager.active_player.metal_trash_cards[0].stats.value
	
	round_manager.active_player.points += round_manager.active_player.metal_trash_cards[0].stats.value
	discarded_card = round_manager.active_player.metal_trash_cards[0]
	round_manager.active_player.metal_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.metal)
	
	action_finished()
	
func _on_organic_pressed() -> void:
	if round_manager.active_player.organic_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		spawn_no_trash_warning()
		return
	
	trash_value = round_manager.active_player.organic_trash_cards[0].stats.value
	
	round_manager.active_player.points += round_manager.active_player.organic_trash_cards[0].stats.value
	discarded_card = round_manager.active_player.organic_trash_cards[0]
	round_manager.active_player.organic_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.organic)
	
	action_finished()
	
func _on_paper_pressed() -> void:
	if round_manager.active_player.paper_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		spawn_no_trash_warning()
		return
	
	trash_value = round_manager.active_player.paper_trash_cards[0].stats.value
	
	round_manager.active_player.points += round_manager.active_player.paper_trash_cards[0].stats.value
	discarded_card = round_manager.active_player.paper_trash_cards[0]
	round_manager.active_player.paper_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.paper)
	
	action_finished()
	
func _on_plastic_pressed() -> void:
	if round_manager.active_player.plastic_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		spawn_no_trash_warning()
		return
	
	trash_value = round_manager.active_player.plastic_trash_cards[0].stats.value
	
	round_manager.active_player.points += round_manager.active_player.plastic_trash_cards[0].stats.value
	discarded_card = round_manager.active_player.plastic_trash_cards[0]
	round_manager.active_player.plastic_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.plastic)
	
	action_finished()
	
#endregion
