extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var hitbox: Area2D
@onready var health_bar = $Health

@export var health = 0
@export var damage = 10

@export var gravity: float = 20

@export var color: Color = Color.WHITE

func _ready():
	sprite.modulate = color
	health_bar.set_health(health)
	
	hitbox.connect("body_entered", _on_hitbox_body_entered)
	sprite.play("Idle")

func hurt(_damge):
	health -= _damge
	
	health_bar.change_health(health)
	if health <= 0:
		queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.hurt(damage)
		
		if get_parent().get_parent().has_method("change_dir"):
			get_parent().get_parent().change_dir()
