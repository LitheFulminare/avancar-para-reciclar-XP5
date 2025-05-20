class_name PathManager
extends Node

enum branches
{
	no_branch,
	branch_A,
	branch_B
}

@export_subgroup("Branch 1")
@export var branch1_A_start: int = 0
@export var branch1_A_end: int = 0
@export var branch1_B_start: int = 0
@export var branch1_B_end: int = 0

@export_subgroup("Branch 2")
@export var branch2_A_start: int = 0
@export var branch2_A_end: int = 0
@export var branch2_B_start: int = 0
@export var branch2_B_end: int = 0

var branch_1_A_size: int
var branch_2_A_size: int

func _ready() -> void:
	branch_1_A_size = branch1_A_end - branch1_A_start
	branch_2_A_size = branch2_A_end - branch2_A_start
