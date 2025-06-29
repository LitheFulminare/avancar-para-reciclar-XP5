# saves and loads player and round data when going to and from minigame scenes

class_name SaveAndLoadManager
extends Node

static func save_data(player_array: Array[Player], current_round: int) -> void:
	for player in player_array:
		var player_data: PlayerData = PlayerData.new()
		
		player_data.square_name = player.square.name
		print(player_data.square_name)
		player_data.points = player.points
		player_data.paper_trash_cards = player.paper_trash_cards
		player_data.plastic_trash_cards = player.plastic_trash_cards
		player_data.metal_trash_cards = player.metal_trash_cards
		player_data.glass_trash_cards = player.glass_trash_cards
		player_data.organic_trash_cards = player.organic_trash_cards
		
		GameManager.players.append(player_data)
		
	GameManager.round = current_round
