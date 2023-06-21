extends Label

var time:float

func reset(tm:int = 0):
	time = tm

# Called when the node enters the scene tree for the first time.
@warning_ignore("integer_division")
func _process(_delta):
	time += _delta
	if int(time) % 60 < 10:
		$".".text = str("0", int(time / 60), " : 0", int(int(time) % 60))
	elif time / 60 < 10:
		$".".text = str("0", int(time / 60), " : ", int(int(time) % 60))
	else :
		$".".text = str(int(time / 60), " : ", int(int(time) % 60))
