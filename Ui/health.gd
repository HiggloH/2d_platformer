extends Control

@onready var health_bar = $ProgressBar
var health: int

func set_health(new_health):
	health = new_health
	health_bar.max_value = health
	health_bar.value = health

func change_health(new_health):
	health_bar.value = new_health
