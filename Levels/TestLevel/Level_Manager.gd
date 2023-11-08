extends Node2D

@onready var start_location = $StartLocation

func _ready():
	GlobalSignals.connect("player_death", _player_death)
	GlobalSignals.connect("win", _win)

func _player_death():
	$Player.global_position = start_location.global_position

func _win():
	$Player.global_position = start_location.global_position
