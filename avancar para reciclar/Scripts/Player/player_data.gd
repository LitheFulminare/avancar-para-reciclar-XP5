# used to store player data between scenes

class_name PlayerData
extends Node

var square_name: String
var points: int
var paper_trash_cards: Array[TrashCard] = []
var plastic_trash_cards: Array[TrashCard] = []
var metal_trash_cards: Array[TrashCard] = []
var glass_trash_cards: Array[TrashCard] = []
var organic_trash_cards: Array[TrashCard] = []
