extends Node

const SAVE_FILE_1 = "user://save_file_1.json"

func load_save_file():
	var save_file = FileAccess.open(SAVE_FILE_1, FileAccess.READ)
	
	if save_file != null:
		var unlocked_levels = save_file.get_line()
		var has_sword = save_file.get_line()
		
		#Convert has_sword from string to bool
		if has_sword == "false":
			has_sword = false
		elif has_sword == "true":
			has_sword = true
		
		Game.unlocked_levels = unlocked_levels
		Game.has_sword = has_sword
