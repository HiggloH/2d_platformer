extends Node2D

@export var body: CharacterBody2D
@export var sprite: AnimatedSprite2D

@onready var raycast = $RayCast2D
@onready var ground_cast = $RayCast2D2

@export var speed: int = 100
#-1 is left and 1 is right
@export var direction = -1
@onready var last_direction = direction

func _physics_process(_delta):
	if raycast.is_colliding() or not ground_cast.is_colliding():
		direction = -direction
	
	if direction != last_direction:
		if direction == -1:
				body.scale.x = -1
		else:
				body.scale.x = -1
	last_direction = direction
	
	body.velocity.x = direction * speed
	
	body.move_and_slide()
