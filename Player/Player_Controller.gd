extends CharacterBody2D

const GRAVITY: float = 1200.0
const WALL_GRAVITY: float = 550.0
const MAX_VELOCITY: Vector2 = Vector2(0, 10000)

@onready var sword_controller: Node2D = preload("res://Player/Weapons/sword_controller.tscn").instantiate()

enum States {
	Idle,
	Jumping,
	Falling,
	WallJumping
}

@export var move_speed: int = 20000
@export var jump_height: int = -22500
var max_jump_velocity: int = -375

var move_direction: float = 0
var last_direction: float = 0 

var current_state: States = States.Idle 

@onready var sprite_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_pos: Marker2D = $SwordPos

var has_sword: bool = false

var jump_ready: bool = false

func instansiate(_has_sword: bool):
	has_sword = _has_sword
	
	if has_sword:
		pickup_sword()

func change_state(new_state: States):
	current_state = new_state

func _physics_process(delta):
	if not is_on_floor():
		if current_state != States.Jumping:
			change_state(States.Falling)
		
		if velocity.y <= MAX_VELOCITY.y:
			velocity.y += GRAVITY * delta
	
	if is_on_floor():
		jump_ready = true
	else:
		jump_ready = false
	
	animate()
	Move(delta)
	
	match current_state:
		States.Idle:
			pass
		States.Jumping:
			if jump_ready:
				jump(delta)
			
		States.Falling:
			if is_on_floor():
				change_state(States.Idle)
	
	move_and_slide()

func animate():
	if move_direction == 1:
		#Flip the sprite right
		sprite_anim.flip_h = false
		
		#move the sword pos the follow the sprite flip
		sword_pos.global_position.x = 8
	elif move_direction == -1:
		#Flip the sprite left
		sprite_anim.flip_h = true
		
		#move the sword pos the follow the sprite flip
		sword_pos.global_position.x = -8
	
	if current_state == States.Falling:
		sprite_anim.play("Falling")
	
	#Play the idle or move animation depending on if you move or not
	if is_on_floor():
		if move_direction == 0:
			sprite_anim.play("idle")
		else:
			sprite_anim.play("Run")

func jump(delta: float):
	if is_on_wall_only():
		velocity.x = -last_direction * (move_speed * 5) * delta
	sprite_anim.play("Jump")
	velocity.y = jump_height * delta
	
	jump_ready = false
	await get_tree().create_timer(0.25).timeout
	change_state(States.Falling)

func Move(delta: float):
	move_direction = Input.get_axis("left", "right")
	
	if move_direction != 0:
		last_direction = move_direction
	
	velocity.x = move_direction * move_speed * delta

func pickup_sword():
	sword_pos.call_deferred("add_child", sword_controller)
	has_sword = true

func _unhandled_input(event):
	if event.is_action_pressed("jump") and jump_ready:
		change_state(States.Jumping)

func _on_hit_box_area_entered(area: Area2D):
	if area.is_in_group("Kill_Zone"):
		GlobalSignals.emit_signal("player_death")
		queue_free()
	
	if area.is_in_group("SwordPickup") and !has_sword:
		area.queue_free()
		pickup_sword()

func _on_hit_box_area_exited(_area):
	pass # Replace with function body.

func _on_hit_box_body_entered(_body):
	pass # Replace with function body.
