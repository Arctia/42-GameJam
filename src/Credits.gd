extends Control

func _input(event):
	if event.is_action_pressed("jump"):
		change_scene()

func change_scene():
	get_tree().change_scene_to_file("res://src/UI/title_screen.tscn")
