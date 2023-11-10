extends Node2D

@onready var start_location = $Marker2D
@onready var player = preload("res://Player/player.tscn").instantiate()

func _ready():
	GlobalSignals.connect("player_death", _player_death)
	GlobalSignals.connect("win", _win)
	
	player.global_position = start_location.global_position
	add_child(player)

func _player_death():
	player.global_position = start_location.global_position
	player.set_health()

func _win():
	player.global_position = start_location.global_position
