class_name BoatMinigameManager
extends Node

@export_category("Parameters")
@export var stage_duration: int

@export_category("Nodes")
@export var timer_clock: TimerClock
@export var trash_parent: Node2D
@export var countdown_text: Label

static var pre_round_phase = true
static var minigame_paused  = true

func _ready() -> void:
	timer_clock.duration = stage_duration
	start_countdown()
	
	trash_parent.child_exiting_tree.connect(trash_collected)
	timer_clock.timer_reached_zero.connect(timer_ended)

## PROBABLY WONT BE USED -->
## trash will be spawned until the timer ends, making this useless
# called when a child of the trash_parent node gets queue_free'd
func trash_collected(_node: Node) -> void:
	# check if there is any remaining trash left
	# it has to be 1 because this value is not updated right after queue_free is called
	if trash_parent.get_child_count() == 1:
		print("minigame ended")

# called on ready
func start_countdown() -> void:
	countdown_text.scale = Vector2.ZERO
	
	await get_tree().create_timer(1).timeout
	tween_label_scale()
	countdown_text.text = "3"
	
	await get_tree().create_timer(1).timeout
	tween_label_scale()
	countdown_text.text = "2"
	
	await get_tree().create_timer(1).timeout
	tween_label_scale()
	countdown_text.text = "1"
	
	await get_tree().create_timer(1).timeout
	tween_label_scale()
	countdown_text.text = "Já!"
	
	await get_tree().create_timer(1).timeout
	countdown_text.text = ""
	
	minigame_paused = false
	pre_round_phase = false
	
	timer_clock.start_timer()

func tween_label_scale() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(countdown_text, "scale", Vector2(1, 1), 0.15)

# called when the timer on the Timer Clock reaches 0
func timer_ended() -> void:
	minigame_paused = true
	await get_tree().create_timer(1).timeout
	countdown_text.text = "Fim de jogo!"
