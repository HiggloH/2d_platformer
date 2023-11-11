extends Node2D

@export var body: CharacterBody2D
@export var sprite: AnimatedSprite2D

@onready var raycast = $RayCast2D
@onready var ground_cast = $RayCast2D2

@export var speed: int = 100
#-1 is left and 1 is right
@export var direction = -1

func _physics_process(_delta):
	if raycast.is_colliding() or not ground_cast.is_colliding():
		direction = -direction
	
	match direction:
		-1:
			sprite.flip_h = false
			#24 is the leagth of the raycast
			raycast.target_position.x = -24
		1:
			sprite.flip_h = true
			#24 is the leagth of the raycast
			raycast.target_position.x = 24
	
	body.velocity.x = direction * speed
	
	body.move_and_slide()
