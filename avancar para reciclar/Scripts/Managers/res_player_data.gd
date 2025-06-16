# saves player variables between scenes

class_name PlayerData
extends Resource

var points: int
var square: Square
var paper_trash_cards: Array[TrashCard] = []
var plastic_trash_cards: Array[TrashCard] = []
var metal_trash_cards: Array[TrashCard] = []
var glass_trash_cards: Array[TrashCard] = []
var organic_trash_cards: Array[TrashCard] = []
