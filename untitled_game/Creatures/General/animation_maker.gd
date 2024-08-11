extends Node

class_name ANIMATION_MAKER

var pathLoader = PATH_LOADER.new()

enum STATES {
	attack,
	death,
	hurt,
	idle,
	walk
}

func load_assets(entityType: String, entityName: String, variant: String) -> Dictionary:
	var path = pathLoader.get_asset_path(entityType, entityName, variant)
	return pathLoader.load_all_animations_subdirectories(path)


func make_animation(entityType: String, entityName: String, variant: String, speed: int, sceneTreePath: NodePath, animPlayer: AnimationPlayer, libraryName: String, animatedSprite: AnimatedSprite2D):
	var sprites = load_assets(entityType, entityName, variant)
	var animationLibrary = AnimationLibrary.new()
	var spriteFrame = SpriteFrames.new()

	for key in sprites.keys():
		var currentSprites = sprites.get(key)
		spriteFrame.add_animation(key)
		for i in range(currentSprites.size()):
			var texture = load(currentSprites[i])
			spriteFrame.add_frame(key, texture)

	animatedSprite.sprite_frames = spriteFrame
	
	for key in sprites.keys():
		var animation = Animation.new()
		var currentSprites = sprites.get(key)
		animation.length = 0.1 * currentSprites.size()+1
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(0, 'AnimatedSprite2D:animation')
		for i in range(currentSprites.size()-1):
			animation.track_insert_key(0, i*0.1, key)
		animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(1, 'AnimatedSprite2D:frame')
		for i in range(currentSprites.size()-1):
			animation.track_insert_key(1, i*0.1, i)
		animationLibrary.add_animation(key, animation)
		
		if key == 'idle' or key == 'walk':
			animation.loop_mode=Animation.LOOP_LINEAR

	animatedSprite.sprite_frames = spriteFrame
	animPlayer.add_animation_library(libraryName, animationLibrary )


func add_points_to_blendspace(animationTree: AnimationTree, libraryName: String, animPlayer: AnimationPlayer):
	animationTree.anim_player = animPlayer.get_path()
	for element in STATES:
		var animation_root_node = AnimationNodeAnimation.new()
		animation_root_node.set_animation(libraryName+element)
		print(libraryName+element)
		var node = animationTree.tree_root.get_node(element)
		node.add_blend_point(animation_root_node, 0)
