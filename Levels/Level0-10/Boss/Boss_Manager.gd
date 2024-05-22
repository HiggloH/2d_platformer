extends Node2D

@onready var anim_player = $AnimationPlayer

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		anim_player.play("Start")
		
		$Area2D.queue_free()
