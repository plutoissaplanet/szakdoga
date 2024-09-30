extends Node2D

# TODO
# section for all the maps the user already has
# published and unpublished section
# if clicked on the editor tool, the user can edit it
# if clicked on the "publish" button, the user can make it available to every other user
# if clicked on the delete --> user can delete it
# show likes and dislikes on the published maps
# user can unpublish maps, and edit them and then republish --> every stat gets lost
# creare new map button
# "go back" button


func _on_create_new_map_pressed():
	createNewScene.create_new_scene()
