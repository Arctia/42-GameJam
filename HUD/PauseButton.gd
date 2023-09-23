extends TextureButton

func _input(event):
	if event.is_action_pressed("pause"): 
		if Game.is_pausable():
			_on_pressed()

func _on_pressed():
	if get_tree().paused == false:
		%Panel.visible = true
		%HBoxContainer.visible = true
		get_tree().paused = true
	elif get_tree().paused == true:
		%Panel.visible = false
		%HBoxContainer.visible = false
		get_tree().paused = false
