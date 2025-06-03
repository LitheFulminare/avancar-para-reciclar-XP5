class_name TimerClock
extends Node2D

signal timer_reached_zero

@export var stage_time: int = 30

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

func _ready() -> void: 
	start_timer()
	
func _process(_delta: float) -> void:
	label.text = str(int(timer.time_left))
	
func start_timer() -> void: 
	timer.start(stage_time)

func _on_timer_timeout() -> void:
	timer_reached_zero.emit()
