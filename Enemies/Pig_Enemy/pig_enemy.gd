extends CharacterBody2D

@export var health = 20
@export var damage = 10

func hurt(damge):
	health -= damge
	
	if health <= 0:
		queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.hurt(damage)
