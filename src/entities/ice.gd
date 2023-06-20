extends Area2D

#var jump_sfx = load()

func on_ice():
	var player = %ash
	if overlaps_body(player):
		return true
	return false
	
