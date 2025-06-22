class_name ScrollingCamera
extends Camera2D

signal finished_zooming_out

var ignore_input: bool = false

var is_zoom_on_cooldown: bool = false
var go_to_starting_pos_after_ZO: bool = false

var zoom_target: Vector2
var starting_position: Vector2

var max_zoom: float = 2.75
var base_zoom_smoothing: float = 8
var zoom_smoothing: float = 8

@export var pan_speed: float = 300
@export var map_background: Sprite2D
@export var zoom_cooldown_timer: Timer

func _ready() -> void:
	zoom_target = zoom
	starting_position = global_position

func _process(delta: float) -> void:
	zoom_in_and_out(delta)
	move_with_keyboard(delta)
	
	
func zoom_in_and_out(delta: float) -> void:
	# is_action_pressed doesn't work with scroll wheel, but I want it to be possible to hold the zoom button
	if Input.is_action_pressed("Camera zoom in") || Input.is_action_just_pressed("Camera zoom in"):
		if !is_zoom_on_cooldown && !ignore_input:
			zoom_cooldown_timer.start()
			is_zoom_on_cooldown = true
			zoom_target *= 1.1
		
	if Input.is_action_pressed("Camera zoom out") || Input.is_action_pressed("Camera zoom out"):
		if !is_zoom_on_cooldown && !ignore_input:
			zoom_cooldown_timer.start()
			is_zoom_on_cooldown = true
			zoom_target *= 0.9
		
	zoom = zoom.slerp(zoom_target, zoom_smoothing * delta)
	
	# basically clamps the zoom
	if zoom.x < 1:
		zoom_target = Vector2(1,1)
		zoom = Vector2(1,1)
		if go_to_starting_pos_after_ZO:
			go_to_starting_position()
			go_to_starting_pos_after_ZO = false
			zoom_smoothing = base_zoom_smoothing
			finished_zooming_out.emit()
		
	elif zoom.x > max_zoom:
		zoom_target = Vector2(max_zoom, max_zoom)

# moves the camera with WASD and arrows
func move_with_keyboard(delta: float) -> void:
	if ignore_input:
		return
	
	var movement_direction: Vector2 = Vector2.ZERO
	
	# used to ensure the camera is not going beyond the limits
	# Godot actually limits the rendering area, not the camera's position, so this is necessary
	var half_screen: Vector2 = get_viewport_rect().size * 0.5 * 1/zoom
	
	if Input.is_action_pressed("Move camera up"):
		if position.y > limit_top + half_screen.y:
			movement_direction.y -= 1
	if Input.is_action_pressed("Move camera down"):
		if position.y < limit_bottom - half_screen.y:
			movement_direction.y += 1
	if Input.is_action_pressed("Move camera left"):
		if position.x > limit_left + half_screen.x:
			movement_direction.x -= 1
	if Input.is_action_pressed("Move camera right"):
		if position.x < limit_right - half_screen.x:
			movement_direction.x += 1
		
	global_position += movement_direction.normalized() * pan_speed * delta
	
	# now due to parallax the camera appears to move faster the more it's zoomed in
	# this prevents that, but it's up to personal preference
	#global_position += movement_direction.normalized() * pan_speed * delta * (1/zoom.x)


func _on_zoom_cooldown_timer_timeout() -> void:
	is_zoom_on_cooldown = false
	
# sets zoom to 0 and checks if the position should be reseted as well
func remove_zoom(go_to_starting_location: bool = false) -> void:
	zoom_target = Vector2.ZERO
	
	# the smoothing weight is decrease so it takes longer to zoom ou (it looks better)
	zoom_smoothing = base_zoom_smoothing * zoom.x / 3.5
	go_to_starting_pos_after_ZO = go_to_starting_location

func zoom_to_location(location: Vector2, zoom_value: float = max_zoom) -> void:
	zoom_target = Vector2(zoom_value, zoom_value)
	global_position = location

func go_to_starting_position() -> void:
	global_position = starting_position
