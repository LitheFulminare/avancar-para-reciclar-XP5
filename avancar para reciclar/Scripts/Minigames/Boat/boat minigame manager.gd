class_name BoatMinigameManager
extends Node

@export_category("Parameters")
@export var stage_duration: int

@export_category("Nodes")
@export var timer_clock: TimerClock
@export var trash_parent: Node2D
@export var countdown: Countdown
@export_subgroup("Players")
@export var player1: Boat
@export var player2: Boat
@export var player3: Boat


static var pre_round_phase = true
static var minigame_paused  = true

func _ready() -> void:
	timer_clock.duration = stage_duration
	countdown.start_countdown()
	
	trash_parent.child_exiting_tree.connect(trash_collected)
	timer_clock.timer_reached_zero.connect(timer_ended)
	countdown.countdown_ended.connect(start_minigame)

## PROBABLY WONT BE USED -->
## trash will be spawned until the timer ends, making this useless
# called when a child of the trash_parent node gets queue_free'd
func trash_collected(_node: Node) -> void:
	# check if there is any remaining trash left
	# it has to be 1 because this value is not updated right after queue_free is called
	if trash_parent.get_child_count() == 1:
		print("minigame ended")

# called when the 'Countdown' script reaches 0 and emits the countdown_ended signal
func start_minigame() -> void:
	minigame_paused = false
	pre_round_phase = false
	
	timer_clock.start_timer()

# called when the timer on the Timer Clock reaches 0
func timer_ended() -> void:
	minigame_paused = true
	await get_tree().create_timer(1).timeout
	countdown.change_text("Fim de jogo!", true)
	await get_tree().create_timer(2).timeout
	
	if player1.points > player2.points && player1.points > player3.points:
		countdown.change_text("Jogador 1 ganhou", false)
	elif player2.points > player1.points && player2.points > player3.points:
		countdown.change_text("Jogador 2 ganhou", false)
	elif player3.points > player1.points && player3.points > player2.points:
		countdown.change_text("Jogador 3 ganhou", false)
		
	elif player1.points == player2.points:
		countdown.change_text("Jogadores 1 e 2 empataram", false)
	elif player1.points == player3.points:
		countdown.change_text("Jogadores 1 e 3 empataram", false)
	elif player2.points == player3.points:
		countdown.change_text("Jogadores 2 e 3 empataram", false)
	elif player1.points == player2.points && player2.points == player3.points:
		countdown.change_text("Todos os jogadores empataram", false)
		
	await get_tree().create_timer(2).timeout
	GameManager.go_to_scene("res://Prototyping/map test.tscn")
