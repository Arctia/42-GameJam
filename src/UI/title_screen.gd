extends Control

func _ready():
	$CenterContainer/btn_start_game.grab_focus()
	_set_modes(Game.get_unlocks())

func _start_game(mode:int=0):
	if mode == 0: Game.hard_mode = false; Game.god_mode = false
	if mode == 1: Game.hard_mode = true; Game.god_mode = false
	elif mode == 2: Game.hard_mode = false; Game.god_mode = true
	$AnimationPlayer.play("flashing")
	$Node2D/ash/AnimationPlayer.play("LookAtMe")
#	$Node2D/ash/AnimationPlayer.seek(0.3)

func _on_animation_player_animation_finished(_anim_name):
	get_tree().change_scene_to_file("res://src/UI/prologue.tscn")

func _set_modes(modes:int=0):
	if modes > 1: $CenterContainer3/btn_soot_game.visible = true
	if modes > 0: $CenterContainer2/btn_hard_game.visible = true
