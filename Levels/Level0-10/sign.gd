extends Area2D

var player_is_in_area = false

@onready var text = $Control

func _process(_delta):
	if player_is_in_area and Input.is_action_just_pressed("use"):
		text.show()
	elif player_is_in_area and Input.is_action_just_released("use"):
		text.hide()
	elif !player_is_in_area:
		text.hide()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_is_in_area = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_is_in_area = false
