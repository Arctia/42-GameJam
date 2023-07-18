extends Control

func _ready():
	$CenterContainer/btn_start_game.grab_focus()

func _start_game():
	$AnimationPlayer.play("flashing")
	$Node2D/ash/AnimationPlayer.play("LookAtMe")
#	$Node2D/ash/AnimationPlayer.seek(0.3)

func _on_animation_player_animation_finished(_anim_name):
	get_tree().change_scene_to_file("res://src/UI/prologue.tscn")
