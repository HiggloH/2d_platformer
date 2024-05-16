extends CharacterBody2D

const GRAVITY: float = 1200.0
const MAX_VELOCITY: Vector2 = Vector2(0, 10000)

enum States {
	Idle,
	Jumping,
	Falling,
	WallJumping
}

@export var move_speed: int = 25000
var move_direction: int = 0
var last_direction: int = 0 

var current_state: States = States.Idle 

func change_state(new_state: States):
	current_state = new_state

func _physics_process(delta):
	if not is_on_floor():
		if velocity.y <= MAX_VELOCITY.y:
			velocity.y += GRAVITY * delta
	
	match current_state:
		States.Idle:
			Move(delta)
		States.Jumping:
			pass
	
	move_and_slide()

func Move(delta: float):
	move_direction = Input.get_axis("left", "right")
	
	velocity.x = move_direction * move_speed * delta

func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		print("jump")

func _on_hit_box_area_entered(area: Area2D):
	if area.is_in_group("Kill_Zone"):
		GlobalSignals.emit_signal("player_death")
		queue_free()

func _on_hit_box_area_exited(area):
	pass # Replace with function body.

func _on_hit_box_body_entered(body):
	pass # Replace with function body.
