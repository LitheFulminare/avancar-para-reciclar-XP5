class_name Player
extends Node2D

signal trash_inventory_changed(trash_type: TrashCardStats.types) # connected to player_stats_hud
signal stopped_moving # connected to player_stopped_moving() on the RoundManager
signal dice_landed
signal second_dice_landed

@export_group("Player parameters")
@export var dice_roll: int = 0
@export var total_cards: int = 0
@export var speed: float = 50
@export var player_color: Color = Color(0.0, 0.749, 0.165)

@export_group("Internal node components")
@export var dice_button: Button
@export var map_button: Button
@export var movement_remaining_label: Label
@export var dice_spawn_point: Marker2D

@export_group("Scene references")
@export var dice_scene_path: PackedScene 

var dice: Dice

var points: int
var paper_trash_cards: Array[TrashCard] = []
var plastic_trash_cards: Array[TrashCard] = []
var metal_trash_cards: Array[TrashCard] = []
var glass_trash_cards: Array[TrashCard] = []
var organic_trash_cards: Array[TrashCard] = []

# doesn't get changed internally
# RoundManager changes right before moving the player
# represents the actual number of the square, and not its index on the array
var square: Square

# used to move player to square using a tween with consistent speed
var target_position: Vector2
var distance_to_target: float
var tween_duration: float

# branch variables
# again, RoundManager uses these
var current_branch: PathManager.branches

func _ready() -> void:
	var new_style_box: StyleBoxFlat = dice_button.get_theme_stylebox("focus").duplicate()
	new_style_box.border_color = player_color
	
	dice_button.add_theme_stylebox_override("focus", new_style_box)
	dice_button.add_theme_stylebox_override("hover", new_style_box)
	map_button.add_theme_stylebox_override("focus", new_style_box)
	map_button.add_theme_stylebox_override("hover", new_style_box)
	
	movement_remaining_label.visible = false
	
	dice_button.visible = false
	map_button.visible = false

func spawn_interaction_buttons(is_first_dice_roll: bool) -> void:
	dice_button.visible = true
	map_button.visible = true
	
	if is_first_dice_roll:
		dice_button.text = "Rolar o primeiro dado"
	else:
		dice_button.text = "Rolar o segundo dado"

func spawn_map_button() -> void:
	map_button.visible = true

func hide_buttons() -> void:
	dice_button.release_focus()
	map_button.release_focus()
	
	dice_button.visible = false
	map_button.visible = false

# adds a trash card to the inventory 
func add_trash(trash_card: TrashCard) -> void:
	match trash_card.stats.type:
		TrashCardStats.types.paper:
			paper_trash_cards.append(trash_card)
		TrashCardStats.types.plastic:
			plastic_trash_cards.append(trash_card)
		TrashCardStats.types.metal:
			metal_trash_cards.append(trash_card)
		TrashCardStats.types.glass:
			glass_trash_cards.append(trash_card)
		TrashCardStats.types.organic:
			organic_trash_cards.append(trash_card)
			
	trash_inventory_changed.emit(trash_card.stats.type)

# called by RoundManager on move()
func move_to_current_square() -> void:
	distance_to_target = global_position.distance_to(square.global_position)
	tween_duration = distance_to_target / speed
	
	var tween = create_tween()
	tween.tween_property(self, "position", square.global_position, tween_duration)
	await tween.finished
	stopped_moving.emit() # connected to player_stopped_moving() on the RoundManager

func update_movement_HUD(remaining_distance: int) -> void:
	movement_remaining_label.visible = true
	movement_remaining_label.text = str(remaining_distance)
	if remaining_distance == 0:
		movement_remaining_label.visible = false

func spawn_dice(result: int, is_first_roll: bool) -> void:
	dice = dice_scene_path.instantiate()
	add_child(dice)
	dice.global_position = dice_spawn_point.global_position
	
	dice.roll_dice(result, is_first_roll)
	dice.dice_landed.connect(on_dice_landed)
	dice.second_dice_landed.connect(on_second_dice_landed)

func on_dice_landed() -> void:
	dice_landed.emit()

func on_second_dice_landed() -> void:
	second_dice_landed.emit()

# maybe I could even connect the signals to hide_buttons to simplify
func _on_dice_button_pressed() -> void:
	hide_buttons()

func _on_map_button_pressed() -> void:
	hide_buttons()
