class_name TrashSpawner
extends Node

@export_subgroup("Parameters")
@export var trash_spawn_interval: float = 2

@export_subgroup("Nodes")
@export var spawn_area: CollisionShape2D
@export var trash_spawn_timer: Timer

# used to store trash scenes and instantiate them during gameplay
const trash_directory: String = "res://Scenes/Minigames/Trash/"
var trash_pool: Array[PackedScene]

# used when spawning trash
var trash_spawn_rect: Rect2

func _ready() -> void:
	# loads Trash scenes and puts them on an array
	load_trash()
	
	trash_spawn_timer.start()
	trash_spawn_rect = spawn_area.shape.get_rect()
	trash_spawn_timer.wait_time = trash_spawn_interval
	trash_spawn_timer.timeout.connect(spawn_trash)

# called on ready(), used to get all "Trash" scenes and put them on an array
func load_trash() -> void:
	var trash_scenes = ResourceLoader.list_directory(trash_directory)
	
	for scene in trash_scenes:
		trash_pool.append(load(trash_directory+scene))

# called when the timer emits the 'timeout' signal
func spawn_trash() -> void:
	# not really the best way to handle pausing, but it's fine for now
	if BoatMinigameManager.minigame_paused:
		return
	
	# instantiate trash
	var trash_scene: PackedScene = trash_pool.pick_random()
	var trash: Trash = trash_scene.instantiate()
	add_child(trash)
	
	#randomize scale and rotation
	trash.apply_boat_minigame_transform()
	
	# get a random point in the spawn rect
	var rand_x: float = randf_range(spawn_area.position.x - trash_spawn_rect.size.x / 2, 
		spawn_area.position.x + trash_spawn_rect.size.x / 2)
	var rand_y: float = randf_range(spawn_area.position.y - trash_spawn_rect.size.y / 2, 
		spawn_area.position.y + trash_spawn_rect.size.y / 2)
	
#region Debug print statments
	print("")
	print("X starting point: " + str(spawn_area.position.x - trash_spawn_rect.size.x / 2))
	print("X ending point: " + str(spawn_area.position.x + trash_spawn_rect.size.x / 2))
	print("Y starting point: " + str(spawn_area.position.y - trash_spawn_rect.size.y / 2))
	print("Y ending point: " + str(spawn_area.position.y + trash_spawn_rect.size.y / 2))
	print("")
	print("X random point: " + str(rand_x))
	print("Y random point: " + str(rand_y))
#endregion
	
	trash.global_position = trash.global_position + Vector2(rand_x, rand_y)
