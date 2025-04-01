# handles main game logic

extends Node

var turn: int = 1; # goes from 1 to 2 or 3 depending on the player count
var current_round: int = 0;
var max_round: int = 20; # maybe give the player the option to ajust this?
