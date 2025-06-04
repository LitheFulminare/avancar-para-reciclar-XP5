class_name BoatMinigameManager
extends Node

@export_group("Trash spawner")
@export var spawn_area: CollisionShape2D
@export var trash_spawn_timer: Timer

@export_group("Timer")
@export var timer_clock: TimerClock

@export_group("Other nodes")
@export var trash_parent: Node2D

static var minigame_paused  = false

# used to store trash scenes and instantiate them during gameplay
const trash_directory: String = "res://Scenes/Minigames/Trash/"
var trash_pool: Array[PackedScene]

func _ready() -> void:
	## TEMPORARY
	trash_spawn_timer.start()
	
	load_trash()
	
	trash_spawn_timer.timeout.connect(spawn_trash)
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

# called on ready(), used to get all "Trash" scenes and put them on an array
func load_trash() -> void:
	var trash_scenes = ResourceLoader.list_directory(trash_directory)
	
	for scene in trash_scenes:
		trash_pool.append(load(trash_directory+scene))

func spawn_trash() -> void:
	# not really the best way to handle pausing, but it's fine for now
	if minigame_paused:
		return
		
	print("trash spawned")
