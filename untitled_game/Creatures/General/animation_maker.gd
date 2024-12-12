extends Node

class_name ANIMATION_MAKER

var pathLoader = PATH_LOADER.new()

enum STATES {
	attack,
	death,
	hurt,
	idle,
	move
}

func load_assets(entityType: String, entityName: String, variant: String) -> Dictionary:
	var path = pathLoader.get_asset_path(entityType, entityName, variant)
	return pathLoader.load_all_animations_subdirectories(path)


func make_animation(entityType: String, entityName: String, variant: String, speed: float, sceneTreePath: NodePath, animPlayer: AnimationPlayer, libraryName: String, animatedSprite: AnimatedSprite2D):
	var sprites = load_assets(entityType, entityName, variant)
	var animationLibrary = AnimationLibrary.new()
	var spriteFrame = SpriteFrames.new()
	
	var frameWidth: int = 382
	var frameHeight: int 

	for key in sprites.keys():
		var currentSpriteSheet = load(sprites.get(key)[0])
		var spriteSheetWidth = currentSpriteSheet.get_width()
		frameHeight = currentSpriteSheet.get_height()
		var numberOfFrames = spriteSheetWidth/frameWidth
		spriteFrame.add_animation(key)
		for i in range(numberOfFrames):
			var x = (i* frameWidth)
			var region = Rect2(x, 1, frameWidth,frameHeight)
			var atlas = AtlasTexture.new()
			atlas.atlas = currentSpriteSheet
			atlas.region = region
			spriteFrame.add_frame(key, atlas)
#
	animatedSprite.sprite_frames = spriteFrame
	
	for key in sprites.keys():
		var animation = Animation.new()
		var currentSpriteSheet = load(sprites.get(key)[0])
		var spriteSheetWidth = currentSpriteSheet.get_width()
		var numberOfFrames = spriteSheetWidth/frameWidth
		animation.length = speed * (numberOfFrames-1)
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(0, str(animatedSprite.get_path())+":animation")
		animation.track_set_interpolation_type(0, Animation.INTERPOLATION_CUBIC)
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(1, str(animatedSprite.get_path())+":frame")
		animation.track_set_interpolation_type(1, Animation.INTERPOLATION_CUBIC)

		for i in range(numberOfFrames):
			animation.track_insert_key(0, i, key)
			animation.track_insert_key(1, i*speed, i)
			
		if key == 'idle' or key == 'move':
			animation.loop_mode=Animation.LOOP_LINEAR
			
		animationLibrary.add_animation(key, animation)

	animatedSprite.sprite_frames = spriteFrame
	animPlayer.add_animation_library(libraryName, animationLibrary )
	

func add_points_to_blendspace(animationTree: AnimationTree, libraryName: String, animPlayer: AnimationPlayer):
	animationTree.anim_player = animPlayer.get_path()
	for element in STATES:
		var animation_root_node = AnimationNodeAnimation.new()
		animation_root_node.set_animation(libraryName+element)
		var node = animationTree.tree_root.get_node(element)
		node.add_blend_point(animation_root_node, 0)
