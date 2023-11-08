extends Path2D

var speed = 1

@onready var path_follow = $PathFollow2D

func _process(_delta):
	path_follow.progress += speed
