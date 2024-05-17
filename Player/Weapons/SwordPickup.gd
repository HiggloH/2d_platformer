extends Area2D

func _ready():
	if Game.has_sword:
		queue_free()
