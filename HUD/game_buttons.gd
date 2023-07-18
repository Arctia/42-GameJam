extends HBoxContainer

signal btn_xaxis(val:int)
signal btn_yaxis(val:int)

# need a check if the other is still pressed
func _on_xaxis_btn(val:int):
	btn_xaxis.emit(val)

# need a check if the other is still pressed
func _on_yaxis_btn(val:int):
	btn_yaxis.emit(val)
