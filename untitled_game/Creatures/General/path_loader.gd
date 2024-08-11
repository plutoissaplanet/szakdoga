extends Node

class_name PATH_LOADER

const BASE_PATH = "res://Creatures/"

func get_asset_path(entityType: String, entityName: String, variant: String, ):
	return BASE_PATH + entityType + '/' + entityName + '/' + variant 
	
func load_asset(entityType: String, entityName: String, variant: String):
	var path = get_asset_path(entityType, entityName, variant)
	return load(path)

func load_all_animations_subdirectories(path: String) -> Dictionary:
	var sprites = {}
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var folder = dir.get_next()
		while folder != "":
			if dir.current_is_dir():
				var frames = []
				var sub_dir_path = path + '/' + folder
				var sub_dir = DirAccess.open(sub_dir_path)
				if sub_dir:
					sub_dir.list_dir_begin()
					var files = sub_dir.get_next()
					while files != "":
						if not sub_dir.current_is_dir():
							if files.ends_with(".png"):
								frames.append(sub_dir_path + '/' + files)
							files=sub_dir.get_next()
					sub_dir.list_dir_end()
				sprites[folder.to_lower()] = frames
			folder = dir.get_next()
		dir.list_dir_end()
	return sprites
