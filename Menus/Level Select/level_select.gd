extends Node2D

func _ready():
	if Game.unlocked_levels[1]:
		$Lock1.visible = false
	if Game.unlocked_levels[2]:
		$Lock2.visible = false

func _on_return_button_down():
	GlobalSignals.emit_signal("return_to_menu")

func _on_tutorial_button_down():
	GlobalSignals.emit_signal("change_level", 0)

func _on_level_1_button_down():
	if Game.unlocked_levels[1]:
		GlobalSignals.emit_signal("change_level", 1)

func _on_level_2_button_down():
	if Game.unlocked_levels[2]:
		GlobalSignals.emit_signal("change_level", 2)
