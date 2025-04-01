# handles main game logic

extends Node

var player_count: int = 3 
var turn: int = 0; # goes from 1 to 2 or 3 depending on the player count
var current_round: int = 1;
var max_round: int = 20; # maybe give the player the option to ajust this?

var rng = RandomNumberGenerator.new()
