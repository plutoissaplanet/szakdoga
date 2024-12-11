extends Node

class_name JSON_FILE_OPERATIONS

func save_json_file(path: String, content: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	content.replace("/", "")
	file.store_string(content)
	
func load_json_file(path: String):
	var file = FileAccess.open(path, FileAccess.READ_WRITE)
	return file
