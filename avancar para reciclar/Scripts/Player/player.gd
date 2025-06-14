class_name Player
extends Node2D

signal trash_inventory_changed(trash_type: TrashCardStats.types) # connected to player_stats_hud
signal stopped_moving # connected to player_stopped_moving() on the RoundManager

@export var dice_roll: int = 0
@export var total_cards: int = 0
@export var speed: float = 50

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

# called by RoundManager on move()
func move_to_current_square() -> void:
	distance_to_target = global_position.distance_to(square.global_position)
	tween_duration = distance_to_target / speed
	
	var tween = create_tween()
	tween.tween_property(self, "position", square.global_position, tween_duration)
	await tween.finished
	stopped_moving.emit() # connected to player_stopped_moving() on the RoundManager
