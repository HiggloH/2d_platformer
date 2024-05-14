extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_resume_button_down():
	visible = false
	
	get_tree().paused = false
 
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		visible = true
		
		get_tree().paused = true

func _on_quit_button_down():
	get_tree().quit()

func _on_return_to_menu_button_down():
	get_tree().paused = false
	
	GlobalSignals.emit_signal("return_to_menu")
