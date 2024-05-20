extends Node2D

@onready var level_0 = preload("res://Levels/Level0-10/tutorial_level.tscn")
@onready var level_1 = preload("res://Levels/Level0-10/level_1.tscn")
@onready var level_2 = preload("res://Levels/Level0-10/level_2.tscn")

var levels: Array
#The first level has the index zero in the level array
#Can be changed form outside the script to start on later levels
var current_level: int = 0
var max_level = 0

var start_location: Vector2 = Vector2.ZERO

func set_level(last_level):
	current_level = last_level

func _ready():
	GlobalSignals.connect("checkpoint", _checkpoint)
	GlobalSignals.connect("player_death", _player_death)
	GlobalSignals.connect("win", _win)
	
	levels.append(level_0)
	levels.append(level_1)
	levels.append(level_2)
	
	max_level = levels.size()
	
	_start()

func _checkpoint(new_location):
	start_location = new_location

func _start():
	var new_level = levels[current_level].instantiate()
	add_child(new_level)
	move_child(get_child(1), 0)

func _player_death():
	while get_child_count() > 1:
		get_child(0).queue_free()
		
		await get_tree().create_timer(0.1).timeout
	
	var level = levels[current_level].instantiate()
	
	if start_location != Vector2.ZERO:
		level.set_start_location(start_location)
	
	call_deferred("add_child", level, 0)
	await get_tree().create_timer(0.3).timeout
	move_child(get_child(1), 0)

func _win():
	start_location = Vector2.ZERO
	
	while get_child_count() > 1:
		get_child(0).queue_free()
		
		await get_tree().create_timer(0.1).timeout
	
	if current_level <= max_level:
		current_level += 1
	
	var new_level = levels[current_level].instantiate()
	
	call_deferred("add_child", new_level)
	await get_tree().create_timer(0.3).timeout
	move_child(get_child(1), 0)
