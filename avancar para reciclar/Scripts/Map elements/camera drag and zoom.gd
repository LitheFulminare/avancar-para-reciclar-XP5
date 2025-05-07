extends Camera2D

var zoom_target: Vector2
@export var pan_speed: float = 300

func _ready() -> void:
	zoom_target = zoom

func _process(delta: float) -> void:
	zoom_with_mouse(delta)
	move_with_keyboard(delta)
	
	
func zoom_with_mouse(delta: float) -> void:
	if Input.is_action_just_pressed("Camera zoom in"):
		zoom_target *= 1.1
		
	if Input.is_action_just_pressed("Camera zoom out"):
		zoom_target *= 0.9
		
	zoom = zoom.slerp(zoom_target, 12 * delta)

func move_with_keyboard(delta: float) -> void:
	var movement_direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("Move camera up"):
		movement_direction.y -= 1
	if Input.is_action_pressed("Move camera down"):
		movement_direction.y += 1
	if Input.is_action_pressed("Move camera left"):
		movement_direction.x -= 1
	if Input.is_action_pressed("Move camera right"):
		movement_direction.x += 1
		
	global_position += movement_direction.normalized() * pan_speed * delta
