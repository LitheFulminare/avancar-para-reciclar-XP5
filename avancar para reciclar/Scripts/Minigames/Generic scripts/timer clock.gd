class_name TimerClock
extends Node2D

signal timer_reached_zero

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

var duration: int

func _process(_delta: float) -> void:
	if BoatMinigameManager.pre_round_phase:
		label.text = str(duration)
		return
	
	label.text = str(int(timer.time_left))
	
func start_timer() -> void: 
	timer.start(duration)

func _on_timer_timeout() -> void:
	timer_reached_zero.emit()
