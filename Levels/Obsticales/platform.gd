extends Node2D

@onready var animation = $AnimationPlayer

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		animation.play("Drop")
