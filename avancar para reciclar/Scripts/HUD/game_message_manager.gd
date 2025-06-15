# used to show text on screen like "Round 1", "Minigame time", etc

class_name GameMessageManager
extends Label

enum players
{
	green,
	yellow,
	red
}

@export var seconday_label: Label

@export var green_color: Color
@export var yellow_color: Color
@export var red_color: Color

func _ready() -> void:
	visible = false

func display_message(message: String) -> void:
	visible = true
	seconday_label.visible = false
	
	text = message

func display_new_round_message(current_round: int) -> void:
	await get_tree().process_frame
	visible = true
	seconday_label.visible = false
	
	text = "Rodada " + str(current_round)
	
func display_current_player(current_player: players) -> void:
	visible = true
	seconday_label.visible = true
	
	
	var player_color_name: String
	var new_color: Color
	
	match current_player:
		players.green:
			new_color = green_color
			player_color_name = "VERDE"
		players.yellow:
			new_color = yellow_color
			player_color_name = "AMARELO"
		players.red:
			new_color = red_color
			player_color_name = "VERMELHO"
	
	text = "Vez do jogador \n" 
	seconday_label.text = "\n" + player_color_name
	seconday_label.add_theme_color_override("font_color", new_color)
