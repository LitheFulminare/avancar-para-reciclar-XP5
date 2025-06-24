class_name DiscardTrashManager
extends Node

@export var round_manager: RoundManager
@export var discard_trash_scene: PackedScene

var discard_trash: DiscardTrash

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

func discard_any_trash() -> void:
	discard_trash.visible = true

func _on_glass_pressed() -> void:
	if round_manager.active_player.glass_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		return
	
	round_manager.active_player.points += round_manager.active_player.glass_trash_cards[0].stats.value
	round_manager.active_player.glass_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.glass)

func _on_metal_pressed() -> void:
	if round_manager.active_player.metal_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		return
	
	round_manager.active_player.points += round_manager.active_player.metal_trash_cards[0].stats.value
	round_manager.active_player.metal_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.metal)
	
func _on_organic_pressed() -> void:
	if round_manager.active_player.organic_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		return
	
	round_manager.active_player.points += round_manager.active_player.organic_trash_cards[0].stats.value
	round_manager.active_player.organic_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.organic)
	
func _on_paper_pressed() -> void:
	if round_manager.active_player.paper_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		return
	
	round_manager.active_player.points += round_manager.active_player.paper_trash_cards[0].stats.value
	round_manager.active_player.paper_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.paper)
	
func _on_plastic_pressed() -> void:
	if round_manager.active_player.plastic_trash_cards.size() == 0:
		discard_trash.spawn_no_trash_warning()
		return
	
	round_manager.active_player.points += round_manager.active_player.plastic_trash_cards[0].stats.value
	round_manager.active_player.plastic_trash_cards.remove_at(0)
	round_manager.active_player.trash_inventory_changed.emit(TrashCardStats.types.plastic)
	
