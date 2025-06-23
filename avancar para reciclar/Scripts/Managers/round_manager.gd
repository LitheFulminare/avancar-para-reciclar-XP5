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

#region variables

@export_group("Managers")
@export var question_card_res_manager: QuestionCardResourceManager
@export var path_manager: PathManager
@export var audio_manager: AudioManager
@export var game_message: GameMessageManager

@export_group("Scene node components")
@export var main_camera: ScrollingCamera
@export var question_card_spawn: Marker2D
@export var first_square: Square
@export var squares_parent_node: Node
@export_subgroup("Branch buttons")
@export var branch1_buttons_parent: Node2D
@export var branch1_A_button: TextureButton
@export var branch1_B_button: TextureButton
@export var branch2_buttons_parent: Node2D
@export var branch2_A_button: TextureButton
@export var branch2_B_button: TextureButton

@export_subgroup("Cards")
@export var question_card_stack: Sprite2D
@export var trash_card_stack: Sprite2D
@export var luck_card_Stack: Sprite2D

@export_subgroup("Branch arrows")
@export var green_arrow: Texture2D
@export var yellow_arrow: Texture2D
@export var red_arrow: Texture2D

@export_subgroup("Players' inventories")
# used to know where to move the trash cards after being drawn
@export var players_inventories: Array[Marker2D]

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

var is_first_dice_roll: bool

#endregion

func _ready() -> void:
	branch1_buttons_parent.visible = false
	branch2_buttons_parent.visible = false
	
	main_camera.ignore_input = true
	
	player_array = players_parent_node.get_children()
	
	#region connect signals
	main_camera.finished_zooming_out.connect(camera_finished_zooming_out)
	main_camera.player_finished_examining_map.connect(player_finished_examining_map)
	
	player1.dice_landed.connect(first_dice_landed)
	player2.dice_landed.connect(first_dice_landed)
	player3.dice_landed.connect(first_dice_landed)
	
	player1.second_dice_landed.connect(second_dice_landed)
	player2.second_dice_landed.connect(second_dice_landed)
	player3.second_dice_landed.connect(second_dice_landed)
	
	player1.stopped_moving.connect(player_stopped_moving)
	player2.stopped_moving.connect(player_stopped_moving)
	player3.stopped_moving.connect(player_stopped_moving)
	
	player1.dice_button.pressed.connect(player_pressed_dice_button)
	player2.dice_button.pressed.connect(player_pressed_dice_button)
	player3.dice_button.pressed.connect(player_pressed_dice_button)
	
	player1.map_button.pressed.connect(player_pressed_map_button)
	player2.map_button.pressed.connect(player_pressed_map_button)
	player3.map_button.pressed.connect(player_pressed_map_button)
	
	player_chose_branch.connect(branch_chosen)
	#endregion
	
	load_player_data()
	
	start_game()
	
func _process(_delta: float) -> void:
	
	if active_player != null && main_camera.ignore_input:
		main_camera.global_position = active_player.global_position

func _input(event: InputEvent) -> void:
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
			
	if Input.is_action_just_pressed("ui_cancel"):
		if !main_camera.ignore_input: 
			main_camera.reset_camera(active_player.global_position)

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
			start_turn()
		
		round_states.first_dice_roll: 
			dice_roll(true)
			
		round_states.second_dice_roll: 
			dice_roll(false)
		
		round_states.move: 
			move()
			current_round_state = round_states.end_turn
			
		round_states.end_turn:
			end_turn()
			
		round_states.end_round:
			end_round()

func start_round() -> void:
	await get_tree().create_timer(2).timeout
	game_message.display_new_round_message(current_round)
	turn = 0
	
	await get_tree().create_timer(2).timeout
	current_round_state = round_states.start_turn
	action()

func start_turn() -> void:
	turn += 1
	active_player = player_array[turn-1]
	game_message.display_current_player(turn-1)
	
	await get_tree().create_timer(2).timeout
	game_message.visible = false
	await get_tree().create_timer(1).timeout
	main_camera.zoom_to_location(active_player.global_position)
	
	await get_tree().create_timer(0.3).timeout
	
	active_player.spawn_interaction_buttons(true)

func player_pressed_dice_button() -> void:
	if current_round_state == round_states.start_turn:
		current_round_state = round_states.first_dice_roll
	elif current_round_state == round_states.first_dice_roll:
		current_round_state = round_states.second_dice_roll
		
	action()

func first_dice_landed() -> void:
	if is_first_dice_roll:
		active_player.spawn_interaction_buttons(false)

func second_dice_landed() -> void:
	await get_tree().create_timer(1.3).timeout
	current_round_state = round_states.move
	action()

func player_pressed_map_button() -> void:
	main_camera.ignore_input = false
	
	branch1_buttons_parent.visible = false
	branch2_buttons_parent.visible = false

func dice_roll(is_first_roll: bool) -> void:
	audio_manager.play_rolling_dice_SFX()
	is_first_dice_roll = is_first_roll
	
	if is_first_dice_roll:
		first_dice_result = GameManager.roll_dice(1, 6)
		active_player.spawn_dice(first_dice_result, is_first_dice_roll)
		print("First dice roll: " + str(first_dice_result))
		#current_round_state = round_states.second_dice_roll
	else:
		second_dice_result = GameManager.roll_dice(1, 6)
		active_player.spawn_dice(second_dice_result, is_first_dice_roll)
		total_dice_result = first_dice_result + second_dice_result
		print("Second dice roll: " + str(second_dice_result))
		# this was written when this part was on action(), but i'll keep it anyways:
			# if there is a special item that makes the player roll another dice I could 
			# add another state here
		

func end_turn() -> void:
	if turn == GameManager.player_count:
		current_round_state = round_states.end_round
	else:
		current_round_state = round_states.start_turn
		
	action()

func end_round():
	current_round += 1
	current_round_state = round_states.start_round
	
	game_message.display_message("Hora do minigame!")
	
	await get_tree().create_timer(1.5).timeout
	
	go_to_minigame()

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
		
		active_player.update_movement_HUD(total_dice_result)
		total_dice_result -= 1
		active_player.move_to_current_square()
	
	else:
		# makes the camera zoom out
		is_player_moving = false

func player_landed_at_fork() -> void:
	active_player.update_movement_HUD(total_dice_result)
	player_at_fork = true # prevents move() from being called again on player_stopped_moving()
	spawn_branch_buttons()
	
func spawn_branch_buttons() -> void:
	active_player.spawn_map_button()
	
	if active_player.square.fork_number == 1:
		branch1_buttons_parent.visible = true
	if active_player.square.fork_number == 2:
		branch2_buttons_parent.visible = true
		
	match turn:
		1:
			branch1_A_button.texture_normal = green_arrow
			branch1_B_button.texture_normal = green_arrow
			
			branch2_A_button.texture_normal = green_arrow
			branch2_B_button.texture_normal = green_arrow
		2:
			branch1_A_button.texture_normal = yellow_arrow
			branch1_B_button.texture_normal = yellow_arrow
			
			branch2_A_button.texture_normal = yellow_arrow
			branch2_B_button.texture_normal = yellow_arrow
		3:
			branch1_A_button.texture_normal = red_arrow
			branch1_B_button.texture_normal = red_arrow
			
			branch2_A_button.texture_normal = red_arrow
			branch2_B_button.texture_normal = red_arrow

# called by move() on the player's script
# emits a signal after the tween ends, signal is connected on this class' move() func
func player_stopped_moving() -> void:
	print("Player stopped moving")
	
	audio_manager.play_move_sfx()
	
	if total_dice_result == 0:
		active_player.update_movement_HUD(0)
	
	if !player_at_fork:
		move()
		
	if !is_player_moving:
		await get_tree().create_timer(1).timeout
		main_camera.remove_zoom(true)
		
		#draw_question_card()
		# this func wont be called all rounds, only when the player lands on quiz squares

func branch_chosen():
	print("Active player's branch: " + str(active_player.current_branch))
	if active_player.current_branch == path_manager.branches.branch_A:
		active_player.square.next_square = active_player.square.branch_A_start
	else:
		active_player.square.next_square = active_player.square.branch_B_start
		
	player_at_fork = false
	active_player.hide_buttons() # hide "Examine map" button
	main_camera.zoom_to_location(active_player.global_position)
	
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

func player_answered(answer_result: bool) -> void:
	# maybe I can put discard trash logic here, not sure yet
	return
	
func question_card_closed() -> void:
	audio_manager.stop_question_card_ost()
	
	await get_tree().create_timer(0.5).timeout
	
	current_round_state = round_states.end_turn
	action()

# maybe this could replace question_card_closed() entirely
func square_action_finished() -> void:
	await get_tree().create_timer(0.5).timeout
	
	current_round_state = round_states.end_turn
	action()

# gives the specified player a trash card
func add_trash(target_player_index: int, trash_type: TrashCardStats) -> void:
	# instantiates the trash card and assign the correct type
	var spawned_trash_card: TrashCard = trash_card.instantiate()
	get_tree().root.add_child(spawned_trash_card)
	spawned_trash_card.update_stats(trash_type)
	
	#spawned_trash_card.position = trash_card_stack.global_position
	#spawned_trash_card.scale = trash_card_stack.scale
	
	move_card_to_center(spawned_trash_card, trash_card_stack)
	
	await get_tree().create_timer(1.5).timeout
	spawned_trash_card.reveal()
	await get_tree().create_timer(1.5).timeout
	
	# move card to player inventory
	var tween = create_tween()
	tween.set_parallel()
	var target_position: Vector2 = players_inventories[target_player_index].global_position
	tween.tween_property(spawned_trash_card, "position", target_position, 0.6)
	tween.tween_property(spawned_trash_card, "scale", Vector2.ZERO, 0.6)
	await tween.finished
	
	# gives the card to the target player
	var player: Player = player_array[target_player_index]
	player.add_trash(spawned_trash_card)
	
	square_action_finished()

func get_random_trash_type() -> TrashCardStats:
	return trash_card_types.pick_random()

# spawns a question card and randomizes its text
func draw_question_card() -> void:
	#instantiates the card
	var question_card: QuestionCard = question_card_scene.instantiate()
	$"../../HUD Canvas Layer".add_child(question_card)
	
	# changes the text, sets position to the card stack nad changes the size
	question_card.set_texts(question_card_res_manager.get_random_question_res())
	#question_card.position = question_card_spawn.global_position
	#question_card.scale = question_card_stack.scale
	
	# moves it smoothly to the center of the screen and makes it bigger
	move_card_to_center(question_card, question_card_stack)
	
	question_card.player_answered.connect(player_answered)
	question_card.tree_exiting.connect(question_card_closed)
	
	await get_tree().create_timer(1.5).timeout
	
	question_card.reveal()
	audio_manager.play_question_card_ost()

## Uses tween to move a card to the center of the screen and make it grow.
## Pass only a node with [color=yellow]postion[/color] and 
## [color=yellow]scale[/color] properties, otherwise it won't work.
func move_card_to_center(card, spawn_node) -> void:
	card.position = spawn_node.global_position
	card.scale = spawn_node.scale
	
	var tween = create_tween()
	tween.set_parallel()
	var screen_mid_point: Vector2 = Vector2(get_viewport().get_visible_rect().size.x/2, 
	get_viewport().get_visible_rect().size.y/2)
	print(screen_mid_point)
	tween.tween_property(card, "position", screen_mid_point, 0.6)
	tween.tween_property(card, "scale", Vector2(1.5,1.5), 0.6)
	await tween.finished
	
	return

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
	
	active_player.square.action()
	#draw_question_card()
	#add_trash(turn-1, get_random_trash_type())

func player_finished_examining_map() -> void:
	if player_at_fork:
		spawn_branch_buttons()
	
	if current_round_state == round_states.start_turn:
		active_player.spawn_interaction_buttons(true)
	elif current_round_state == round_states.first_dice_roll:
		active_player.spawn_interaction_buttons(false)
	
func go_to_minigame() -> void:
	var players: Array[Player] = [player1, player2, player3]
	SaveAndLoadManager.save_data(players, current_round)
	GameManager.go_to_scene("res://Scenes/Minigames/Boat minigame/Boat minigame.tscn")

func load_player_data():
	if GameManager.players.size() == 0:
		return
	
	var players: Array[Player] = [player1, player2, player3]
	for i in GameManager.players.size():
		
		print(players[i].square)
		players[i].square = squares_parent_node.find_child(GameManager.players[i].square_name)
		print(players[i].square)
		players[i].points = GameManager.players[i].points
		players[i].paper_trash_cards = GameManager.players[i].paper_trash_cards
		players[i].plastic_trash_cards = GameManager.players[i].plastic_trash_cards
		players[i].metal_trash_cards = GameManager.players[i].metal_trash_cards
		players[i].glass_trash_cards = GameManager.players[i].glass_trash_cards
		players[i].organic_trash_cards = GameManager.players[i].organic_trash_cards
		
		players[i].global_position = players[i].square.global_position
		
	current_round = GameManager.round
	GameManager.players.clear()

# I can combine these 4 into 2 methods
func _on_branch_1_a_button_pressed() -> void:
	active_player.current_branch = path_manager.branches.branch_A
	player_chose_branch.emit()
	branch1_buttons_parent.visible = false


func _on_branch_1_b_button_pressed() -> void:
	active_player.current_branch = path_manager.branches.branch_B
	player_chose_branch.emit()
	branch1_buttons_parent.visible = false


func _on_branch_2_a_button_pressed() -> void:
	branch2_buttons_parent.visible = false
	active_player.current_branch = path_manager.branches.branch_A
	player_chose_branch.emit()


func _on_branch_2_b_button_pressed() -> void:
	branch2_buttons_parent.visible = false
	active_player.current_branch = path_manager.branches.branch_B
	player_chose_branch.emit()
