## AUTOLOADED SCRIPT
# handles main game logic
extends Node

var current_scene = null

var player_count: int = 3 
var max_round: int = 20; # maybe give the player the option to ajust this?

var round: int
var players: Array[PlayerData]

var rng = RandomNumberGenerator.new()

# used to give some trash cards to player only at the start of the match
var give_starting_trash: bool = false
var trash_cards_given: int = 0
var starting_cards_index: int = 0

var give_trash_after_minigame: bool
var player1_won: bool
var player2_won: bool
var player3_won: bool

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func go_to_scene(scene_path: String) -> void:
	call_deferred("_deferred_scene_change", scene_path)

func _deferred_scene_change(scene_path: String) -> void:
	current_scene.free()
	var new_scene = load(scene_path)
	current_scene = new_scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func roll_dice(from: int, to: int) -> int:
	rng.randomize()
	return rng.randi_range(from, to)
