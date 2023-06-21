extends Node2D

signal new_level

func _on_new_level_to_the_next_level(pos:Vector2):
	new_level.emit(pos)
