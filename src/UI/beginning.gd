extends Control

var dialogues:Array = [
	"Rovent...",
#	"Your being is simple yet majestic.",
#	Raise and fill your
#	reality.",
	"Go higher and higher.",
	"That's where you do belong"]

var dialogue_count:int = 0
var dialogue_writing:bool = false

func _ready():
	_on_btn_forward_pressed()

func _input(event):
	if event.is_action_released("jump"):
		_on_btn_forward_pressed()

func _on_btn_forward_pressed() -> void:
	if dialogue_writing:
		dialogue_writing = false
		$DialogueControl.skip()
	else:
		dialogue_writing = true
		if dialogue_count >= len(dialogues):
			_to_the_game()
			return
		$DialogueControl.reset(dialogues[dialogue_count])
		dialogue_count += 1

func _on_dialogue_control_reach_the_end():
	dialogue_writing = false

func _to_the_game() -> void:
	$AnimationPlayer.play("flashing")

func _on_btn_skip_pressed() -> void:
	_to_the_game()

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "flashing"):
		self.get_tree().change_scene_to_file("res://src/UI/game_screen.tscn")
