extends CanvasLayer

signal start_game
signal level_select

func _on_quit_button_down():
	get_tree().quit()

func _on_level_select_button_down():
	emit_signal("level_select")

func _on_start_button_down():
	emit_signal("start_game")
