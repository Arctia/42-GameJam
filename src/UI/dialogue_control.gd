#@tool
extends Label
signal reach_the_end

@export var dialogue:String = ""
@export var frame_rate:float = 0.25

var sec:float = 0
var i:int = 0

func _ready():
	pass

func _process(dt):
	if dialogue == self.text: return
	
	sec += dt
	if sec >= frame_rate:
		self.text = self.text + dialogue[i]
		i += 1
		sec = 0
	
	if dialogue == self.text: reach_the_end.emit()

func reset(dia:String):
	self.dialogue = dia
	self.text = ""
	self.i = 0
	self.sec = 0

func skip() -> void:
	self.text = dialogue
	reach_the_end.emit()
	
