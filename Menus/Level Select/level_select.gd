extends Node2D

func _on_return_button_down():
	GlobalSignals.emit_signal("return_to_menu")
