class_name DiscardTrashManager
extends Node

@export var round_manager: RoundManager
@export var discard_trash_scene: PackedScene

var discard_trash: DiscardTrash

func _ready() -> void:
	discard_trash = discard_trash_scene.instantiate()
	add_child(discard_trash)
	discard_trash.visible = false
	
	connect_signals()

func connect_signals() -> void:
	discard_trash.glass_button_pressed.connect(_on_glass_pressed)
	discard_trash.metal_button_pressed.connect(_on_metal_pressed)
	discard_trash.organic_button_pressed.connect(_on_organic_pressed)
	discard_trash.paper_button_pressed.connect(_on_paper_pressed)
	discard_trash.plastic_button_pressed.connect(_on_plastic_pressed)

func discard_any_trash() -> void:
	discard_trash.visible = true

func _on_glass_pressed() -> void:
	print("Glass pressed")

func _on_metal_pressed() -> void:
	print("Metal pressed")
	
func _on_organic_pressed() -> void:
	print("Organic pressed")
	
func _on_paper_pressed() -> void:
	print("Paper pressed")
	
func _on_plastic_pressed() -> void:
	print("Plastic pressed")
