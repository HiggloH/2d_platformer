extends Node

const SAVE_FILE_1 = "user://save_file_1.json"

func load():
	var save_file = FileAccess.open(SAVE_FILE_1, FileAccess.READ)
	
	if save_file != null:
		var unlocked_levels = save_file.get_line()
		
		Game.unlocked_levels = unlocked_levels
