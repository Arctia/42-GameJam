#@tool
extends Label
signal reach_the_end

@export var dialogue:String = ""
@export var frame_rate:float = 0.25
@export var no_bg:bool = false
@export var execute:bool = true
@export var bg_color:Color = "#14040c"
@export var btn_disabled:bool = false

var sec:float = 0
var i:int = 0

func _ready():
	if no_bg: $ColorRect.visible = false
	$ColorRect.color = bg_color
	if not self.btn_disabled:
		$Button.visible = true
		$Button.disabled = false

func _process(dt):
	if not self.execute: return
	if dialogue == self.text: return
	
	sec += dt
	if sec >= frame_rate:
		self.text = self.text + dialogue[i]
		i += 1
		sec = 0
	
	if dialogue == self.text: reach_the_end.emit()

func _play(dia:String) -> void:
	self.visible = true
	self.execute = true
	if not self.btn_disabled:
		$Button.visible = true
		$Button.disabled = false
	self.reset(dia)

func reset(dia:String) -> void:
	self.dialogue = dia
	self.text = ""
	self.i = 0
	self.sec = 0

func skip() -> void:
	self.text = dialogue
	reach_the_end.emit()

func _input(event):
	if (event.is_action_pressed("jump")):
		_on_button_pressed()

func _on_button_pressed():
	if self.dialogue != self.text:
		self.text = self.dialogue
		reach_the_end.emit()
	else:
		self.visible = false
		$Button.disabled = true
		$Button.visible = false
		self.get_tree().paused = false
