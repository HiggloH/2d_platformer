extends Node2D

@onready var start_location: Marker2D = $Marker2D
@onready var player = preload("res://Player/player.tscn").instantiate()

var new_location: Vector2 = Vector2.ZERO

func _ready():
	if new_location != Vector2.ZERO:
		start_location.global_position = new_location
	
	player.global_position = start_location.global_position
	call_deferred("add_child", player)

func set_start_location(new_position):
	new_location = new_position
