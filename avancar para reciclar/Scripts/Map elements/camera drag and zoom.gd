extends Camera2D

var zoom_target: Vector2

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
	if Input.is_action_pressed("Move camera up"):
		global_position.y -= 200 * delta
	if Input.is_action_pressed("Move camera down"):
		global_position.y += 200 * delta
	if Input.is_action_pressed("Move camera left"):
		global_position.x -= 200 * delta
	if Input.is_action_pressed("Move camera right"):
		global_position.x += 200 * delta
