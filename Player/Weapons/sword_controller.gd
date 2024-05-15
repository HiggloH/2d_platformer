extends Node2D

@export var damage = 25

@onready var sword = $Sword
@onready var sword_area = $Sword/Area2D

@onready var sword_sprite = $Sword/Sprite2D
var sword_rotation_degrees = 125

var is_attacking = false

func attack():
	var tween = create_tween()
	
	sword_area.monitoring = true
	tween.tween_property(sword, "rotation_degrees", sword_rotation_degrees, 0.3)
	tween.tween_interval(0.2)
	tween.tween_property(sword, "rotation_degrees", 0, 0.4)
	sword_area.monitoring = false
	
	tween.tween_interval(1)
	
	await tween.finished
	is_attacking = false

func flip():
	sword_rotation_degrees = sword_rotation_degrees * -1
	
	sword_sprite.flip_h = !sword_sprite.flip_h

func _unhandled_input(event):
	if event.is_action_pressed("Attack") and !is_attacking:
		is_attacking = true
		
		attack()
