extends CharacterBody2D

@export var speed: int = 200
@export var jump_height: int = -250
var damage = 10
@export var health = 100

@export var gravity: float = 10

@onready var animation = $AnimatedSprite2D

func _physics_process(_delta):
	velocity.y += gravity 
	
	move()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_height
		animation.play("Jump")
	
	move_and_slide()

func move():
	var direction = Input.get_axis("left", "right")
	
	if direction == -1:
		animation.flip_h = true
	elif direction == 1:
		animation.flip_h = false
	
	if is_on_floor():
		if direction == 0:
			animation.play("idle")
		else:
			animation.play("Run")
	
	
	velocity.x = direction * speed

func _on_hit_box_area_entered(area: Area2D):
	if area.is_in_group("Kill_Zone"):
		GlobalSignals.emit_signal("player_death")
	
	if area.is_in_group("Enemy_Hitbox"):
		area.get_parent().hurt(damage)
		
		velocity.y = jump_height

func hurt(_damage):
	health -= _damage
	
	if health <= 0:
		GlobalSignals.emit_signal("player_death")
