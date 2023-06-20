extends Control

var	background = AudioServer.get_bus_index("Master")


func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(background, value)
	if value == -30:
		AudioServer.set_bus_mute(background, true)
	else:
		AudioServer.set_bus_mute(background, false)
