class_name Boat
extends Area2D

signal trash_collected

# video reference:
# https://www.youtube.com/watch?v=HFEpqsy0VSc

@onready var starting_pos_y: float = position.y

@export_group("Scene managers")
@export var score_display: ScoreDisplay

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
	# makes the boat go up and down
	position.y = get_sine() + starting_pos_y
	line.set_point_position(line.get_point_count() - 1, hook.position)
	
	if hooked_trash != null:
		hooked_trash.global_position = hook.global_position
	
# called by Split Input Manager
func move_hook(direction: Vector2, delta: float) -> void:
	hook.position += direction.normalized() * 125 * delta
	
	# clamp hook movement
	if hook.position.y < 241:
		hook.position.y = 241
	elif hook.global_position.x < 10:
		hook.global_position.x = 10
	elif hook.global_position.y > get_viewport_rect().size.y - 10:
		hook.global_position.y = get_viewport_rect().size.y - 10
	elif hook.global_position.x > get_viewport_rect().size.x - 10:
		hook.global_position.x = get_viewport_rect().size.x - 10

# used to make the boat go up and down
func get_sine() -> float:
	return sin(TimeTracker.time * speed) * amplitude

# the hook's 'area_entered' signal is connected to this funcion
func hooked(area: Area2D) -> void:
	# hook colliding with trash
	if area.is_in_group("Trash"):
		hooked_trash = area
		trash_collected.emit()
		print(str(self.name) + " hooked " + str(hooked_trash.name))
		
	# hook colliding with the player
	if area.is_in_group("Player"):
		if hooked_trash != null:
			hooked_trash.queue_free()
			trash_collected.emit()
			area.add_point()
			print(str(area.name) + " collected trash")

# called by hooked() when the hook collided with an Area2D in the "Player" group
func add_point() -> void:
	points += 1
	score_display.update_score(str(points))
