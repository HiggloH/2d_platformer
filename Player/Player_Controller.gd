extends CharacterBody2D

const GRAVITY: float = 1200.0
const WALL_GRAVITY: float = 250.0
const MAX_VELOCITY: Vector2 = Vector2(0, 1000)
const MAX_WALL_VELOCITY: Vector2 = Vector2(0, 350)

@onready var sword_controller: Node2D = preload("res://Player/Weapons/sword_controller.tscn").instantiate()

enum States {
	Idle,
	Jumping,
	Falling,
	WallJumping,
	Knockback
}

@export var move_speed: int = 15500
@export var jump_height: int = -15000
var max_jump_velocity: int = -375

var move_direction: float = 0
var last_direction: float = 0 

@export var health: int = 100
var damage: int = 10

var current_state: States = States.Idle

#Barn referencer
@onready var sprite_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var i_frame: Timer = $IFrames
@onready var knockback_timer: Timer = $KockbackTimer
@onready var health_bar: Control = $Health
@onready var sword_pos: Marker2D = $SwordPos

var has_sword: bool = false

var jump_ready: bool = false
var can_hurt: bool = true
var ignore_wall: bool = false

func _ready():
	health_bar.set_health(health)
	
	if Game.has_sword:
		pickup_sword()

func change_state(new_state: States):
	if new_state == States.WallJumping:
		velocity.x = 0
	
	current_state = new_state

func _physics_process(delta):
	if not is_on_floor() and not is_on_wall():
		if current_state != States.Falling:
			if current_state != States.Jumping or current_state == States.WallJumping:
				change_state(States.Falling)
	
	if !ignore_wall:
		if is_on_wall() and current_state == States.Falling:
			velocity.y = 0
			
			if current_state != States.WallJumping:
				change_state(States.WallJumping)
		
			jump_ready = true
	
	animate()
	
	if current_state != States.WallJumping:
		Move(delta)
	
	match current_state:
		States.Idle:
			if is_on_floor():
				jump_ready = true
			else:
				jump_ready = false
		States.Jumping:
			if jump_ready:
				jump(delta)
		States.Falling:
			if velocity.y <= MAX_VELOCITY.y:
				velocity.y += GRAVITY * delta
			
			if is_on_floor():
				change_state(States.Idle)
		States.WallJumping:
			wall_jump(delta)
	
	move_and_slide()

func animate():
	if move_direction == 1:
		#Flip the sprite right
		sprite_anim.flip_h = false
			
		#move the sword pos the follow the sprite flip
		sword_pos.position.x = 8
	elif move_direction == -1:
		#Flip the sprite left
		sprite_anim.flip_h = true
			
		#move the sword pos the follow the sprite flip
		sword_pos.position.x = -8
	
	if current_state == States.Falling:
		sprite_anim.play("Falling")
	elif current_state == States.WallJumping:
		sprite_anim.play("Wall_Jump")
	
	#Play the idle or move animation depending on if you move or not
	if is_on_floor():
		if move_direction == 0:
			sprite_anim.play("idle")
		else:
			sprite_anim.play("Run")

func wall_jump(delta: float):
	if velocity.y < MAX_WALL_VELOCITY.y:
		velocity.y += WALL_GRAVITY * delta

func jump(delta: float):
	if is_on_wall_only():
		velocity.x = -last_direction * (move_speed * 5) * delta
	sprite_anim.play("Jump")
	velocity.y = jump_height * delta
	
	jump_ready = false
	await get_tree().create_timer(0.25).timeout
	change_state(States.Falling)

func hurt(_damage):
	if can_hurt:
		can_hurt = false
		
		health -= _damage
		jump_ready = true
		
		health_bar.change_health(health)
		
		if health <= 0:
			GlobalSignals.emit_signal("player_death")
			queue_free()
		
		i_frame.start()
		knockback_timer.start()

func Move(delta: float):
	move_direction = Input.get_axis("left", "right")
	
	if has_sword:
		if move_direction != last_direction and move_direction != 0 and last_direction != 0:
			sword_controller.flip()
	
	if move_direction != 0:
		last_direction = move_direction
	
	velocity.x = move_direction * move_speed * delta

func pickup_sword():
	sword_pos.call_deferred("add_child", sword_controller)
	has_sword = true

func _unhandled_input(event):
	if event.is_action_pressed("jump") and jump_ready and current_state != States.Falling:
		change_state(States.Jumping)

func _on_hit_box_area_entered(area: Area2D):
	if area.is_in_group("Kill_Zone"):
		GlobalSignals.emit_signal("player_death")
		queue_free()
	
	if area.is_in_group("SwordPickup") and !has_sword:
		Game.has_sword = true
		
		area.queue_free()
		pickup_sword()
	
	if area.is_in_group("Ignore"):
		ignore_wall = true
	
	if area.is_in_group("Enemy_Hitbox"):
		if area.get_parent().hurt(damage):
			area.get_parent().hurt(damage)
		else:
			print("Area does not have a hurt function")
		
		#Lauch player up after bounsing on ememy
		jump_ready = true
		change_state(States.Jumping)

func _on_hit_box_area_exited(area: Area2D):
	if area.is_in_group("Ignore"):
		ignore_wall = false

func _on_hit_box_body_entered(body):
	if body.is_in_group("Ignore"):
		ignore_wall = true

func _on_hit_box_body_exited(body):
	if body.is_in_group("Ignore"):
		ignore_wall = false
