class_name Boat
extends Area2D

# video reference:
# https://www.youtube.com/watch?v=HFEpqsy0VSc

@onready var starting_pos_y: float = position.y

@export_group("Node components")
@export var line: Line2D
@export var hook: Area2D

@export_group("Water amplitude")
@export var min_amplitude: float = 1.5
@export var max_amplitude: float = 2.5

@export_group("Water speed")
@export var min_speed: float = 1.5
@export var max_speed: float = 2.5

var amplitude: float = 2
var speed: float = 2

# prob won't be used
var is_hook_going_down: bool = true

var hooked_trash: Area2D

var points: int = 0

func _ready() -> void:
	# randomizes movement amplitude and speed
	# I wanted this to randomize every cycle, but cheking position.y == starting_pos_y doesn't work
	randomize()
	amplitude = randf_range(min_amplitude, max_amplitude)
	speed = randf_range(min_speed, max_speed)
	hook.area_entered.connect(hooked)

func _process(_delta: float) -> void: 
	position.y = get_sine() + starting_pos_y
	line.set_point_position(line.get_point_count() - 1, hook.position)
	
	if hooked_trash != null:
		hooked_trash.global_position = hook.global_position
	
func move_hook(direction: Vector2, delta: float) -> void:
	hook.position += direction.normalized() * 75 * delta

func get_sine() -> float:
	return sin(TimeTracker.time * speed) * amplitude

func hooked(area: Area2D) -> void:
	if area.is_in_group("Trash"):
		hooked_trash = area
		print(str(self.name) + " hooked " + str(hooked_trash.name))
	if area.is_in_group("Player"):
		print(str(self.name) + " collected trash")
