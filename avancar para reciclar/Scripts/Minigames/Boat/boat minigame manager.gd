class_name BoatMinigameManager
extends Node

@export var timer_clock: TimerClock
@export var trash_parent: Node2D

func _ready() -> void:
	trash_parent.child_exiting_tree.connect(trash_collected)
	timer_clock.timer_reached_zero.connect(timer_ended)

func trash_collected(_node: Node) -> void:
	# check if there is any remaining trash left
	# it has to be 1 because this value is not updated right after queue_free is called
	if trash_parent.get_child_count() == 1:
		print("minigame ended")

func timer_ended() -> void:
	print("MINIGAME ENDED")
