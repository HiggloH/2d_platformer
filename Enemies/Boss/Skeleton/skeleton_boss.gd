extends CharacterBody2D

enum States {
	Idle,
	Run,
	Retrite,
	Attack1,
	Attack2
}

@onready var attack_area_1 = $Attack1_Area
@onready var attack_area_2 = $Attack2_Area

@onready var anim_player = $AnimatedSprite2D

func change_state(new_state: States):
	attack_area_1.monitorable = false
	attack_area_2.monitorable = false

func attack_2():
	attack_area_2.monitorable = true

func attack_1():
	attack_area_1.monitorable = true
