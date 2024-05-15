extends Node2D

@onready var main_menu = preload("res://Menus/Main/main_menu.tscn")
@onready var game = preload("res://Levels/Managers/Level/level_manager.tscn")

var current_level = 0
var max_level = 1

func _ready():
	GlobalSignals.connect("return_to_menu", spawn_menu)
	GlobalSignals.connect("win", win)
	
	spawn_menu()

func win():
	if current_level < max_level:
		current_level += 1

func spawn_menu():
	if get_children()  != []:
		for child in get_children():
			child.queue_free()
	
	var new_menu = main_menu.instantiate()
	add_child(new_menu)
	
	new_menu.connect("start_game", start_game)
	new_menu.connect("level_select", level_select)

func start_game():
	get_child(0).queue_free()
	
	var new_game = game.instantiate()
	new_game.set_level(current_level)
	add_child(new_game)

func level_select():
	print("Level select")

