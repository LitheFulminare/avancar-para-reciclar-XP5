# handles core game loop

class_name RoundManager
extends Node

signal player_chose_branch()

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

@export_group("Managers")
@export var question_card_res_manager: QuestionCardResourceManager
@export var path_manager: PathManager

@export_group("Scene node components")
@export var main_camera: ScrollingCamera
@export var question_card_spawn: Marker2D
@export var first_square: Square
@export var squares_parent_node: Node
@export var card_stack: Sprite2D
@export var game_message: GameMessageManager

var current_round_state: round_states = round_states.start_round

var turn: int = 0 # goes from 1 to 2 or 3 depending on the player count
var current_round: int = 1

var first_dice_result: int = 0
var second_dice_result: int = 0
var total_dice_result: int = 0

var player_at_fork: bool = false

# used to know if camera should be zoomed in or out
var is_player_moving: bool = false

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

@export_group("Players")
@export var players_parent_node: Node
@export var player1: Player
@export var player2: Player
@export var player3: Player

@onready var square_array: Array[Square] = get_squares()
var player_array: Array[Node]

func _ready() -> void:
	player_array = players_parent_node.get_children()
	
	#region connect signals
	main_camera.connect("finished_zooming_out", camera_finished_zooming_out)
	
	player1.stopped_moving.connect(player_stopped_moving)
	player2.stopped_moving.connect(player_stopped_moving)
	player3.stopped_moving.connect(player_stopped_moving)
	
	player_chose_branch.connect(branch_chosen)
	#endregion
	
	start_game()
	
func _process(_delta: float) -> void:
	
	if active_player != null:
		main_camera.global_position = active_player.global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Confirm"):
		next_turn();
		
	# won't be like this forever
	# prob a button will be spawned and call the group or something
	# then the method called will handle this things
	if Input.is_key_pressed(KEY_1):
		if player_at_fork:
			active_player.current_branch = path_manager.branches.branch_A
			player_chose_branch.emit()
			
	if Input.is_key_pressed(KEY_2):
		if player_at_fork:
			active_player.current_branch = path_manager.branches.branch_B
			player_chose_branch.emit()

# called at the start of the game
func start_game() -> void:
	next_turn()

func next_turn() -> void:
	action()

# gets the current round state and decides what to do
func action() -> void:
	match current_round_state:
		round_states.start_round:
			start_round()
		
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

func start_round():
	await get_tree().create_timer(2).timeout
	game_message.display_new_round_message(current_round)
	turn = 0
	
	await get_tree().create_timer(2).timeout
	current_round_state = round_states.start_turn
	action()

func move(bypass_fork_check: bool = false) -> void:
	if total_dice_result > 0:
		# used to make the camera zoom in
		is_player_moving = true
		
		# on game start
		if active_player.square == null:
			active_player.square = first_square
			
		else:
			# when at a fork and no branch chosen yet
			if active_player.square.is_fork && !bypass_fork_check:
				player_landed_at_fork()
				return
			else:
				active_player.square = active_player.square.next_square
		
		total_dice_result -= 1
		active_player.move_to_current_square()
	
	else:
		# makes the camera zoom out
		is_player_moving = false

func player_landed_at_fork() -> void:
	player_at_fork = true # prevents move() from being called again on player_stopped_moving()
	print("")
	print("Press 1 to go to branch A")
	print("Press 2 to go to branch B")

# called by move() on the player's script
# emits a signal after the tween ends, signal is connected on this class' move() func
func player_stopped_moving() -> void:
	print("Player stopped moving")
	
	if !player_at_fork:
		move()
		
	if !is_player_moving:
		await get_tree().create_timer(1).timeout
		main_camera.remove_zoom(true)
		# now no square has a resource/type, so calling this func will throw an error
		#square_array[active_player.current_square-1].action()
		
		#draw_question_card()
		# this func wont be called all rounds, only when the player lands on quiz squares

func branch_chosen():
	print("Active player's branch: " + str(active_player.current_branch))
	if active_player.current_branch == path_manager.branches.branch_A:
		active_player.square.next_square = active_player.square.branch_A_start
	else:
		active_player.square.next_square = active_player.square.branch_B_start
		
	player_at_fork = false
		
	move(true)

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
	spawned_trash_card.update_stats(trash_type)
	
	# gives the card to the target player
	var player: Player = player_array[target_player_index]
	player.add_trash(spawned_trash_card)

func get_random_trash_type() -> TrashCardStats:
	return trash_card_types.pick_random()

# spawns a question card and randomizes its text
func draw_question_card() -> void:
	#instantiates the card
	var question_card: QuestionCard = question_card_scene.instantiate()
	$"../../CanvasLayer".add_child(question_card)
	
	# changes the text, sets position to the card stack nad changes the size
	question_card.set_texts(question_card_res_manager.get_random_question_res())
	question_card.position = question_card_spawn.global_position
	question_card.scale = card_stack.scale
	
	# moves it smoothly to the center of the screen and makes it bigger
	var tween = create_tween()
	tween.set_parallel()
	var screen_mid_point: Vector2 = Vector2(get_viewport().get_visible_rect().size.x/2, 
	get_viewport().get_visible_rect().size.y/2)
	print(screen_mid_point)
	tween.tween_property(question_card, "position", screen_mid_point, 0.6)
	tween.tween_property(question_card, "scale", Vector2(1.5,1.5), 0.6)
	await tween.finished
	
	await get_tree().create_timer(1).timeout
	question_card.reveal()

# returns array of the squares
# get_children() only returns an array of node so you have to come up with your own solution
func get_squares() -> Array[Square]:
	var nodes: Array[Node] = squares_parent_node.get_children()
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
	add_trash(turn-1, get_random_trash_type())
