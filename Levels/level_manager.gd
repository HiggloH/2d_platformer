extends Node2D

@onready var start_location: Marker2D = $Marker2D
@onready var player = preload("res://Player/player.tscn").instantiate()

func _ready():
	player.global_position = start_location.global_position
	call_deferred("add_child", player)
