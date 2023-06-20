extends TextureButton

# Called when the node enters the scene tree for the first time.
func _on_pressed():
	if get_tree().paused == false:
		$MenuButton.visible = true
		$OptionButton.visible = true
		get_tree().paused = true
	elif get_tree().paused == true:
		$MenuButton.visible = false
		$OptionButton.visible = false
		get_tree().paused = false
