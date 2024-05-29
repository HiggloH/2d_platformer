extends CharacterBody2D

const GRAVITY: float = 1200.0

enum States {
	Idle,
	Run,
	Retrite,
	Attack
}

var current_state: States

@onready var attack_area_1 = $Attack1_Area
@onready var attack_area_2 = $Attack2_Area
@onready var attack_timer = $AttackTimer

@onready var player_retite_detection_left = $PlayerDetection/Left
@onready var player_retite_detection_right = $PlayerDetection/Right

@onready var anim_player = $AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO
var player_direction: int = 0

var move_speed: int = 15000
var health: int = 350

func change_state(new_state: States):
	velocity = Vector2.ZERO
	
	attack_area_1.monitorable = false
	attack_area_2.monitorable = false
	
	if current_state == States.Attack:
		attack_timer.start()
	
	current_state = new_state

func start():
	change_state(States.Idle)

func _physics_process(delta):
	match current_state:
		States.Idle:
			if not is_on_floor():
				velocity.y += GRAVITY * delta
			
			Idle()
		States.Retrite:
			Retrite(delta)
		States.Attack:
			attack(delta)
	
	if current_state != States.Retrite and current_state != States.Attack:
		if player_retite_detection_left.is_colliding() or player_retite_detection_right.is_colliding():
			change_state(States.Retrite)
	
	move_and_slide()

func Idle():
	anim_player.play("idle")

func Run(delta: float):
	#Run back anbd forth randomly
	pass

func Retrite(delta: float):
	anim_player.stop()
	
	#Run away from the player
	if player_retite_detection_left.is_colliding():
		#Run to the right
		player_direction = 1
	elif player_retite_detection_right.is_colliding():
		#Run to the left
		player_direction = -1
	
	velocity.x = player_direction * move_speed * delta
	
	if not player_retite_detection_left.is_colliding() or not player_retite_detection_right.is_colliding():
		change_state(States.Idle)

func attack(delta: float):
	#Choose attack and move close to the player
	var c_attack = randi_range(0, 1)
	
	if not player_retite_detection_left.is_colliding() or not player_retite_detection_right.is_colliding():
		velocity.x = player_direction * move_speed * delta
	else:
		if c_attack == 0:
			attack_1()
		elif c_attack == 1:
			attack_2()

func attack_2():
	anim_player.play("Attack2")
	attack_area_2.monitorable = true
	
	await anim_player.animation_finished
	change_state(States.Idle)

func attack_1():
	anim_player.play("Attack1")
	attack_area_1.monitorable = true
	
	await anim_player.animation_finished
	change_state(States.Idle)

func hurt(hurt_damage: int):
	health -= hurt_damage
	print(health)
	
	if health <= 0:
		queue_free()

func _on_attack_timer_timeout():
	change_state(States.Attack)
