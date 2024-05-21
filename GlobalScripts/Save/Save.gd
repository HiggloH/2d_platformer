extends Node

const SAVE_FILE_1 = "user://save_file_1.json"

func save():
	var unlocked_levels = Game.unlocked_levels
	
	var save_file = FileAccess.open(SAVE_FILE_1, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(unlocked_levels))
	
	save_file.close()
