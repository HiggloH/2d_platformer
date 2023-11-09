extends CharacterBody2D

@export var speed: int = 200
@export var jump_height: int = -250
var damage = 10
var knockback: int = 550
@export var health = 100

@export var gravity: float = 10
var direction
var last_direction

@onready var animation = $AnimatedSprite2D
@onready var health_bar = $Health

var jump_ready: bool = false

func _ready():
	health_bar.set_health(health)

func _physics_process(_delta):
	if is_on_wall():
		jump_ready = true
		animation.play("Wall_Jump")
		
		velocity.y = 0
	else:
		velocity.y += gravity
		animation.play("Jump")
	
	move()
	if jump_ready and Input.is_action_just_pressed("jump"):
		if is_on_wall():
			velocity.x = -last_direction * (speed * 2)
		velocity.y = jump_height
		jump_ready = false
		animation.play("Jump")
	
	if is_on_floor():
		jump_ready = true
	else:
		jump_ready = false
	
	move_and_slide()

func move():
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		last_direction = direction
	
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
	jump_ready = true
	var knockback_dir = -last_direction
	var new_pos = global_position.x + (knockback_dir * knockback)
	
	global_position.x = lerp(global_position.x, new_pos, 0.1)
	
	health_bar.change_health(health)
	
	if health <= 0:
		GlobalSignals.emit_signal("player_death")

func set_health():
	health = 100
	health_bar.set_health(health)

func _on_hit_box_body_entered(body):
	#Unstuck the player by moving it up
	if body.is_in_group("Level"):
		$CollisionShape2D.set_deferred("disabled", true)
		global_position.y += jump_height / 4
		$CollisionShape2D.set_deferred("disabled", false)
