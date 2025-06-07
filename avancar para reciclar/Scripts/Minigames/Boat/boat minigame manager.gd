class_name BoatMinigameManager
extends Node

@export_category("Nodes")
@export_group("Timer")
@export var timer_clock: TimerClock

@export_group("Other nodes")
@export var trash_parent: Node2D

static var minigame_paused  = false

func _ready() -> void:
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

# called when the timer on the Timer Clock reaches 0
func timer_ended() -> void:
	minigame_paused = true
