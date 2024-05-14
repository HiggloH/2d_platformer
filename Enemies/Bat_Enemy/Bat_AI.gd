extends Node2D

var is_moving = false

func _physics_process(_delta):
	if !is_moving:
		is_moving = true
		animation()

func animation():
	var tween = create_tween()
	var start_y = global_position.y
	
	tween.tween_property(get_parent(), "position:y", global_position.y - 24, 1)
	tween.tween_interval(1)
	tween.tween_property(get_parent(), "position:y", global_position.y + 48, 2)
	tween.tween_interval(1)
	tween.tween_property(get_parent(), "position:y", start_y, 1)
	tween.tween_interval(3)
	
	await tween.finished
	is_moving = false
