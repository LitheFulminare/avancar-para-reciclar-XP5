## AUTOLOADED SCRIPT
# handles main game logic
extends Node

var current_scene = null

var player_count: int = 3 
var max_round: int = 20; # maybe give the player the option to ajust this?

var rng = RandomNumberGenerator.new()

var player_data = {}

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
	
func save_player_data(player_index: int, player: Player) -> void:
	var data: PlayerData = PlayerData.new()
	
	print("")
	print(player.square)
	data.points = player.points
	data.square = player.square
	data.paper_trash_cards = player.paper_trash_cards
	data.plastic_trash_cards = player.plastic_trash_cards
	data.metal_trash_cards = player.metal_trash_cards
	data.glass_trash_cards = player.glass_trash_cards
	data.organic_trash_cards = player.organic_trash_cards
	player_data[player_index] = data

func load_player_data(player_index: int, player: Node):
	if player_data.has(player_index):
		var data: PlayerData = player_data[player_index]
		
		player.points = data.points
		player.square = data.square
		player.paper_trash_cards = data.paper_trash_cards
		player.plastic_trash_cards = data.plastic_trash_cards
		player.metal_trash_cards = data.metal_trash_cards
		player.glass_trash_cards = data.glass_trash_cards
		player.organic_trash_cards = data.organic_trash_cards
