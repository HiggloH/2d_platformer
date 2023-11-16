extends Node2D

@onready var level_0 = preload("res://Levels/Level0-10/tutorial_level.tscn")
@onready var level_1 = preload("res://Levels/Level0-10/level_1.tscn")

var levels: Array
#The first level has the index zero in the level array
@export var current_level: int = 0

var start_location: Vector2 = Vector2.ZERO

func _ready():
	GlobalSignals.connect("checkpoint", _checkpoint)
	GlobalSignals.connect("player_death", _player_death)
	GlobalSignals.connect("win", _win)
	
	levels.append(level_0)
	levels.append(level_1)
	
	_start()

func _checkpoint(new_location):
	start_location = new_location

func _start():
	var new_level = levels[current_level].instantiate()
	add_child(new_level)

func _player_death():
	get_child(0).queue_free()
	
	var level = levels[current_level].instantiate()
	
	if start_location != Vector2.ZERO:
		level.set_start_location(start_location)
		
	call_deferred("add_child", level)

func _win():
	get_child(0).queue_free()
	current_level += 1
	
	var new_level = levels[current_level].instantiate()
	call_deferred("add_child", new_level)
