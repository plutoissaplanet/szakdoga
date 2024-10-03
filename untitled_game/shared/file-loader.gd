extends Node

#var path = "res://Game Assets/Minigames/Puzzle/"
	#var dir = DirAccess.open(path)
	#var randomPictureIndex = randi_range(0,20)
	#if dir:
		#dir.list_dir_begin()
		#if randomPictureIndex == 0:
			#var picture = dir.get_next()
			#if not dir.current_is_dir():
				#selectedPicturePath = path + picture
		#else:
			#var picture
			#while randomPictureIndex != 0:
				#picture = dir.get_next()
				#randomPictureIndex -= 1
			#if not dir.current_is_dir():
				#if not picture.ends_with('.jpg'):
					#picture = dir.get_next()
				#selectedPicturePath = path + picture
		#dir.list_dir_end()
		
		#func _load_all_lights_on_textures():
	#var path = "res://Game Assets/Minigames/Wiring/"
	#var dir = DirAccess.open(path)
	#if dir:
		#dir.list_dir_begin()
		#var texture = dir.get_next()
		#while texture != "":
			#if not dir.current_is_dir() and texture.begins_with('circle') and texture.ends_with('.png'):
				#var texturePath = path + texture
				#lightsOnTextures[texture.split('_')[1]] = load(texturePath)
			#texture = dir.get_next()
		#dir.list_dir_end()
		
func load_assets_1_level_deep(path: String, fileExtension: String ) -> Dictionary:
	var loadedAssets = {}
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var texture = dir.get_next()
		while texture != "":
			if not dir.current_is_dir() and texture.ends_with(fileExtension):
				var texturePath = path+ "/" + texture
				loadedAssets[texture.get_basename()] = load(texturePath)
			texture =  dir.get_next()
		dir.list_dir_end()
		
	if loadedAssets.size() != 0:
		return loadedAssets
	else:
		print("No assets have been loaded")
		return {}
	
func load_assets_2_level_deep(path: String, subpath: String):
	pass
