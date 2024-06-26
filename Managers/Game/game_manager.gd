extends Node2D

@onready var main_menu = preload("res://Menus/Main/main_menu.tscn")
@onready var level_select_menu = preload("res://Menus/Level Select/level_select.tscn")
@onready var game = preload("res://Levels/Managers/Level/level_manager.tscn")

@export var current_level = 0
var max_level = 2

func _ready():
	Load.load_save_file()
	
	GlobalSignals.connect("change_level", change_level)
	GlobalSignals.connect("return_to_menu", spawn_menu)
	GlobalSignals.connect("win", win)
	
	spawn_menu()

func change_level(level: int):
	if level <= max_level:
		current_level = level
	
	start_game()

func win():
	if current_level < max_level:
		current_level += 1

func spawn_menu():
	if get_children() != []:
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
	if get_children() != []:
		for child in get_children():
			child.queue_free()
	
	var new_menu = level_select_menu.instantiate()
	call_deferred("add_child", new_menu)

