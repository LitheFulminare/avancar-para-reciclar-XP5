# handles core game loop

class_name RoundManager
extends Node

enum round_states 
{ 
	start_round, 
	start_turn, 
	first_dice_roll, 
	second_dice_roll, 
	move, 
	end_turn, 
	end_round 
}

@export var question_card_res_manager: QuestionCardResourceManager
@export var main_camera: ScrollingCamera
@export var question_card_spawn: Marker2D

var current_round_state: round_states = round_states.start_round

var turn: int = 0 # goes from 1 to 2 or 3 depending on the player count
var current_round: int = 1

var first_dice_result: int = 0
var second_dice_result: int = 0
var total_dice_result: int = 0

# for when the player's dice roll exceeds the board's number of squares
# saves what they're supposed to move after going back to the start square
var remaining_distance : int = 0

var active_player: Player

const glass_card_stats: TrashCardStats = preload("res://Resources/Cards/Trash cards/glass.tres")
const metal_card_stats: TrashCardStats = preload("res://Resources/Cards/Trash cards/metal.tres")
const organic_card_stats: TrashCardStats = preload("res://Resources/Cards/Trash cards/organic.tres")
const paper_card_stats: TrashCardStats = preload("res://Resources/Cards/Trash cards/paper.tres")
const plastic_card_stats: TrashCardStats = preload("res://Resources/Cards/Trash cards/plastic.tres")

const question_card_scene: PackedScene = preload("res://Scenes/Cards/Question card.tscn")

var trash_card_types: Array[TrashCardStats] = [
	glass_card_stats,
	organic_card_stats,
	paper_card_stats,
	paper_card_stats,
	plastic_card_stats
]

const trash_card_path: String = "res://Scenes/Cards/Trash card.tscn"
var trash_card: PackedScene = preload(trash_card_path)

@onready var player1: Player = $"../Players/Player 1"
@onready var player2: Player = $"../Players/Player 2"
@onready var player3: Player = $"../Players/Player 3"

@onready var player_array: Array[Node] = $"../Players".get_children()
@onready var square_array: Array[Square] = get_squares()

func _ready() -> void:
	main_camera.connect("finished_zooming_out", camera_finished_zooming_out)
	start_game()
	
func _process(delta: float) -> void:
	if active_player != null:
		main_camera.global_position = active_player.global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Confirm"):
		next_turn();

# called at the start of the game
func start_game() -> void:
	next_turn()

func next_turn() -> void:
	action()

# gets the current round state and decides what to do
# note:  I could change the current round and call action again to be recursive, 
# but all action would happen at once, which is not what I want.
func action() -> void:
	match current_round_state:
		round_states.start_round:
			print("Starting round: " + str(current_round))
			turn = 0
			current_round_state = round_states.start_turn
		
		round_states.start_turn:
			turn += 1
			active_player = player_array[turn-1]
			print(active_player.name + "'s turn")
			main_camera.zoom_to_location(active_player.global_position)
			current_round_state = round_states.first_dice_roll
		
		round_states.first_dice_roll: 
			first_dice_result = GameManager.roll_dice(1, 6)
			print("First dice roll: " + str(first_dice_result))
			current_round_state = round_states.second_dice_roll
			
		round_states.second_dice_roll: 
			second_dice_result = GameManager.roll_dice(1, 6)
			total_dice_result = first_dice_result + second_dice_result
			print("Second dice roll: " + str(second_dice_result))
			# if there is a special item that makes the player roll another dice I could 
			# add another state here
			current_round_state = round_states.move
		
		round_states.move: 
			move()
			current_round_state = round_states.end_turn
			
		round_states.end_turn:
			if turn == GameManager.player_count:
				# maybe I could change the state (like I'm doing already) and calling action() again
				# then it automatically triggers the end of the round
				print("Last turn ended. Press again to finish the round")
				current_round_state = round_states.end_round
			else:
				print("Turn ended")
				print("")
				current_round_state = round_states.start_turn
			
		round_states.end_round:
			print("Round ended")
			print("")
			current_round += 1
			current_round_state = round_states.start_round

func move() -> void:
	# prevents the signal being connected twice to a function
	if !active_player.stopped_moving.is_connected(player_stopped_moving):
		active_player.stopped_moving.connect(player_stopped_moving) 
	
	# when the player passed through the start and there are squares left to walk	
	if remaining_distance != 0:
		total_dice_result = remaining_distance
		remaining_distance = 0
		active_player.current_square = total_dice_result
	
	# when the player's dice roll exceeds the board's size
	elif active_player.current_square + total_dice_result > square_array.size():
		print("Player passed through the start")
		
		# makes the player move to end of the board and calculates what's left
		var squares_moved : int = square_array.size() - active_player.current_square
		remaining_distance = total_dice_result - squares_moved
		active_player.current_square = square_array.size()
		print("Remaining distance: " + str(remaining_distance))
		
	# when the player's dice roll doesn't exceed the board's size
	else:
		active_player.current_square += total_dice_result
	
	active_player.move.emit(square_array[active_player.current_square-1].global_position)
	
	

# called by move() on the player's script
# emits a signal after the tween ends, signal is connected on this class' move() func
func player_stopped_moving() -> void:
	print("Player stopped moving")
	if remaining_distance != 0:
		move()
	else:
		await get_tree().create_timer(1).timeout
		main_camera.remove_zoom(true)
		# now no square has a resource/type, so calling this func will throw an error
		#square_array[active_player.current_square-1].action()
		
		#draw_question_card()
		# this func wont be called all rounds, only when the player lands on quiz squares

# this is NOT how actions are gonna be handled anymore, 
# this is only still here in case I need to remember something
#func square_action() -> void:
	#var card_scene = preload("res://Scenes/Cards/Question card.tscn")
	#var card: QuestionCard = card_scene.instantiate()
	#get_tree().root.add_child(card)
	#
	## gives the active_player a random trash card
	#add_trash(turn-1, get_random_trash_type())

# gives the specified player a trash card
func add_trash(target_player_index: int, trash_type: TrashCardStats) -> void:
	# instantiates the trash card and assign the correct type
	var spawned_trash_card: TrashCard = trash_card.instantiate()
	get_tree().root.add_child(spawned_trash_card)
	spawned_trash_card.stats = trash_type
	
	# gives the card to the target player
	var player: Player = player_array[target_player_index]
	player.trash_cards.append(spawned_trash_card)

func get_random_trash_type() -> TrashCardStats:
	return trash_card_types.pick_random()

# spawns a question card and randomizes its text
# gets called by action() on the SquareManager
## not complete, will have some more visual stuff going on
func draw_question_card() -> void:
	var question_card: QuestionCard = question_card_scene.instantiate()
	get_tree().root.add_child(question_card)
	question_card.set_texts(question_card_res_manager.get_random_question_res())
	question_card.position = question_card_spawn.global_position
	await get_tree().create_timer(1).timeout
	question_card.reveal()

# returns array of the squares
# get_children() only returns an array of node so you have to come up with your own solution
func get_squares() -> Array[Square]:
	var nodes: Array[Node] = $"../Squares".get_children()
	var squares: Array[Square] = []
	for node in nodes:
		if node is Square:
			squares.append(node)
		else: 
			printerr("Found a node on 'Squares' that is a member of a class other than 'Square'")
			get_tree().paused = true
			
	return squares

func camera_finished_zooming_out() -> void:
	await get_tree().create_timer(1).timeout
	draw_question_card()
