class_name BoatMinigameManager
extends Node

@export_category("Parameters")
@export var stage_duration: int

@export_category("Nodes")
@export var timer_clock: TimerClock
@export var trash_parent: Node2D
@export var countdown: Countdown
@export var audio_manager: AudioManager
@export_subgroup("Players")
@export var player1: Boat
@export var player2: Boat
@export var player3: Boat


static var pre_round_phase = true
static var minigame_paused  = true

func _ready() -> void:
	timer_clock.duration = stage_duration
	countdown.start_countdown()
	
	player1.trash_collected.connect(trash_collected)
	player2.trash_collected.connect(trash_collected)
	player3.trash_collected.connect(trash_collected)
	
	timer_clock.timer_reached_zero.connect(timer_ended)
	countdown.countdown_ended.connect(start_minigame)

func trash_collected() -> void:
	audio_manager.play_trash_collected_sfx()

# called when the 'Countdown' script reaches 0 and emits the countdown_ended signal
func start_minigame() -> void:
	minigame_paused = false
	pre_round_phase = false
	
	timer_clock.start_timer()
	audio_manager.play_boat_minigame_ost()

# called when the timer on the Timer Clock reaches 0
func timer_ended() -> void:
	minigame_paused = true
	audio_manager.stop_boat_minigame_ost()
	await get_tree().create_timer(1).timeout
	countdown.change_text("Fim de jogo!", true)
	await get_tree().create_timer(2).timeout
	
	GameManager.give_trash_after_minigame = true
	
	if player1.points > player2.points && player1.points > player3.points:
		countdown.change_text("Jogador 1 ganhou", false)
		GameManager.player1_won = true
	elif player2.points > player1.points && player2.points > player3.points:
		countdown.change_text("Jogador 2 ganhou", false)
		GameManager.player2_won = true
	elif player3.points > player1.points && player3.points > player2.points:
		countdown.change_text("Jogador 3 ganhou", false)
		GameManager.player3_won = true
		
	elif player1.points == player2.points:
		countdown.change_text("Jogadores 1 e 2 empataram", false)
		GameManager.player1_won = true
		GameManager.player2_won = true
		if player1.points == player3.points:
			countdown.change_text("Todos os jogadores empataram", false)
			GameManager.give_trash_after_minigame = false
	elif player1.points == player3.points:
		countdown.change_text("Jogadores 1 e 3 empataram", false)
		GameManager.player1_won = true
		GameManager.player3_won = true
	elif player2.points == player3.points:
		countdown.change_text("Jogadores 2 e 3 empataram", false)
		GameManager.player2_won = true
		GameManager.player3_won = true
		
	await get_tree().create_timer(2).timeout
	GameManager.go_to_scene("res://Scenes/Game/map test.tscn")
