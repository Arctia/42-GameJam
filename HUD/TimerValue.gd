extends Label

# Called when the node enters the scene tree for the first time.
@warning_ignore("integer_division")
func _process(_delta):
	if (Time.get_ticks_msec() / 1000) % 60 < 10:
		$".".text = str("0", Time.get_ticks_msec() / 1000 / 60, " : 0", int((Time.get_ticks_msec() / 1000) % 60))
	elif Time.get_ticks_msec() / 1000 / 60 < 10:
		$".".text = str("0", Time.get_ticks_msec() / 1000 / 60, " : ", int((Time.get_ticks_msec() / 1000) % 60))
	else :
		$".".text = str(Time.get_ticks_msec() / 1000 / 60, " : ", int((Time.get_ticks_msec() / 1000) % 60))
