extends Node2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("Idle")

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		GlobalSignals.emit_signal("checkpoint", global_position)
		
		#Deploy the flag then change the animation to flag out idle
		sprite.play("Flag_Out")
		await sprite.animation_looped
		sprite.play("Flag_Out_Idle")
