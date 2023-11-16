extends CharacterBody2D

@onready var bullet = preload("res://Enemies/Bee_Enemy/bee_bullet.tscn")
@export var bullet_spawn_point: Marker2D

@onready var health_bar = $Health

@onready var attack_cooldown = $AttackCooldown
@onready var sprite = $AnimatedSprite2D

@export var speed: int = 50
@export var health: int = 40
@export var damage: int = 15

var target: CharacterBody2D
var target_pos: Vector2

var stopMoving: bool = false
var attack_ready: bool = false

func _process(_delta):
	if !stopMoving:
		if target == null:
			velocity = Vector2.ZERO
		else:
			var attack_bool: bool
			if attack_ready:
				attack_bool = get_random_bool()
			else:
				attack_bool = false
			
			match attack_bool:
				true:
					attack()
				false:
					move_to_target()
	
	move_and_slide()

func attack():
	attack_ready = false
	sprite.play("Attack")
	
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = bullet_spawn_point.global_position
	
	add_child(new_bullet)
	print(bullet_spawn_point.global_position)
	print(new_bullet.global_position)

func get_random_bool() -> bool:
	randomize()
	var rng = RandomNumberGenerator.new()
	var max_value = 1
	var min_value = 0
	
	var value = rng.randi_range(min_value, max_value)
	
	match value:
		0:
			return true
		1:
			return false
		_:
			return false

func move_to_target():
	sprite.play("Idle")
	target_pos = target.global_position
	
	var direction = global_position.direction_to(target_pos)
	
	velocity = direction * speed

func hurt(_damage):
	health -= _damage
	
	health_bar.change_health(health)
	if health <= 0:
		queue_free()

#Start moving if the player is in the collision zone
func _on_attackzone_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		
		attack_cooldown.start()

func _on_attackzone_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		
		attack_cooldown.stop()

#Stop moving if player is to close
func _on_stop_zone_body_entered(body):
	if body.is_in_group("Player"):
		stopMoving = true

func _on_stop_zone_body_exited(body):
	if body.is_in_group("Player"):
		stopMoving = false

func _on_attack_cooldown_timeout():
	attack_ready = true
