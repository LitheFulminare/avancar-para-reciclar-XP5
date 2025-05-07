extends Camera2D

var zoom_target: Vector2
@export var pan_speed: float = 300

@export var map_background: Sprite2D

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
	
	if zoom_target.x < 1:
		zoom_target.x = 1
	if zoom_target.y < 1:
		zoom_target.y = 1

func move_with_keyboard(delta: float) -> void:
	var movement_direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("Move camera up"):
		if position.y > limit_top:
			movement_direction.y -= 1
	if Input.is_action_pressed("Move camera down"):
		if position.y < limit_bottom:
			movement_direction.y += 1
	if Input.is_action_pressed("Move camera left"):
		if position.x > limit_left:
			movement_direction.x -= 1
	if Input.is_action_pressed("Move camera right"):
		if position.x < limit_right:
			movement_direction.x += 1
		
	global_position += movement_direction.normalized() * pan_speed * delta
	
	# now due to parallax the camera appears to move faster the more it's zoomed in
	# this prevents that, but it's up to personal preference
	#global_position += movement_direction.normalized() * pan_speed * delta * (1/zoom.x)
