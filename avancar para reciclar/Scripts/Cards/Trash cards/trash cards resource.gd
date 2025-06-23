class_name TrashCardStats
extends Resource

# used this video as reference
# https://youtu.be/zbAKzM-Odb4?si=XDBEmFU3WCLhv9Pi

enum types 
{ 
	paper,
	plastic,
	metal,
	glass,
	organic
}

@export var sprites: Array[Texture2D]
@export var background_card: Array[Texture2D]
@export var value: int
@export var type: types

# unnecessary
# the the video did it cuz it translates the color name (enum) to the color's code
func get_type() -> types:
	return type

func get_random_sprite() -> Texture2D:
	return sprites.pick_random()
