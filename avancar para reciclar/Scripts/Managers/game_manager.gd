## AUTOLOADED SCRIPT
# handles main game logic
extends Node

var player_count: int = 3 
var max_round: int = 20; # maybe give the player the option to ajust this?

var rng = RandomNumberGenerator.new()

func roll_dice(from: int, to: int) -> int:
	rng.randomize()
	return rng.randi_range(from, to)
