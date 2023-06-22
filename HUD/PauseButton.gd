extends TextureButton

func _input(event):
	if event.is_action_pressed("pause"): _on_pressed()

# Called when the node enters the scene tree for the first time.
func _on_pressed():
	if get_tree().paused == false:
		%Panel.visible = true
		%HBoxContainer.visible = true
		get_tree().paused = true
	elif get_tree().paused == true:
		%Panel.visible = false
		%HBoxContainer.visible = false
		get_tree().paused = false
