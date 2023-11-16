extends CharacterBody2D

@export var speed: int = 200
@export var jump_height: int = -250
@export var unstuck_hieght: int = 150
var damage = 10
var knockback_force: int = 10
var kockback: bool = false
@export var health = 100

@export var gravity: float = 10
@export var wall_gravity: float = 50
var direction
var last_direction

@onready var animation = $AnimatedSprite2D
@onready var health_bar = $Health
@onready var kockback_timer = $KockbackTimer

var jump_ready: bool = false
var ignore_wall: bool = false

func _ready():
	health_bar.set_health(health)

func _physics_process(_delta):
	if is_on_wall() and not ignore_wall:
		velocity.y = 0
		jump_ready = true
		animation.play("Wall_Jump")
		
		velocity.y += wall_gravity
	elif not is_on_floor():
		velocity.y += gravity
		animation.play("Jump")
	
	if kockback:
		global_position.x += knockback_force * -last_direction
	
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
	
	if is_on_wall():
		velocity.x = last_direction * speed
	else:
		velocity.x = direction * speed

func _on_hit_box_area_entered(area: Area2D):
	if area.is_in_group("Kill_Zone"):
		GlobalSignals.emit_signal("player_death")
		queue_free()
		print("player death")
	
	if area.is_in_group("Ignore"):
		ignore_wall = true
	
	if area.is_in_group("Enemy_Hitbox"):
		area.get_parent().hurt(damage)
		
		velocity.y = jump_height

func hurt(_damage):
	health -= _damage
	jump_ready = true
	
	health_bar.change_health(health)
	
	if health <= 0:
		GlobalSignals.emit_signal("player_death")
		queue_free()
	
	kockback = true
	kockback_timer.start()

func set_health():
	health = 100
	health_bar.set_health(health)

func _on_hit_box_body_entered(body):
	#Unstuck the player by moving it up
	if body.is_in_group("Level"):
		$CollisionShape2D.set_deferred("disabled", true)
		global_position.y -= unstuck_hieght
		$CollisionShape2D.set_deferred("disabled", false)

func _on_hit_box_area_exited(area):
	if area.is_in_group("Ignore"):
		ignore_wall = false

func _on_kockback_timer_timeout():
	kockback = false

func _unhandled_input(event):
	if event.is_action_pressed("reset"):
		GlobalSignals.emit_signal("player_death")
