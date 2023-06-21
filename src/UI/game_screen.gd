extends Control

@onready var player:Object = %ash
@onready var HUD:Object = %HUD

var level = 0

var intermezzi:Dictionary = {
	1: "There's always a first time
	to move around.",
	2: "There's always a first time
	to being stitched.",
	4: "There's always a first time
	to ice-skate.",
	5: "There's always a first time
	to truly jump.",
	6: "There's always a first time
	to feel the breeze."
} 

func _ready():
	$AnimationPlayer.play("remove_flash")
	HUD.get_lives(player.lives)
	HUD.reset_time()
	#_to_new_level(Vector2.ZERO, 9)
	#pass

func _process(_dt):
	if HUD != null:
		#HUD.get_lives(player.lives)
		HUD.get_ashes(player.ashes_amount)

func _raise_level():
	level += 1
	if level in intermezzi: 
		$DialogueControl._play(intermezzi[level])
		self.get_tree().paused = true
	if level % 3 == 0:
		var tween = self.create_tween()
		tween.tween_property(%ash, "ashes_amount", 100, 0.3)
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_SINE)
		tween.play()
		#%ash.ashes_amount = 100.0

# ---------------------------------------------------------------------------- #
# --- New Level Logic

var last_checkpoint:Vector2 = Vector2(410.0, 534.0)

func _to_new_level(_pos:Vector2 = Vector2.ZERO, how_many:int=1) -> void:
	%ash.position.y -= 40
	last_checkpoint = %ash.position
	var tween = self.create_tween()
	tween.tween_property(%Game, "position:y", %Game.position.y + (14 * 32) * how_many, 0.6)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.play()
	
	var tween2 = self.create_tween()
	tween2.tween_property(%greywall, "position:y", %greywall.position.y + (15 * 32) * how_many, 0.6)
	tween2.set_ease(Tween.EASE_IN)
	tween2.set_trans(Tween.TRANS_SINE)
	tween2.play()
	
	_move_background()
	_raise_level()

# ---------------------------------------------------------------------------- #
# --- Parallax

@onready var bg_arr = [%Sprite2D4, %Sprite2D3, %Sprite2D2, %Sprite2D]
@export var par_var = 15

func _move_background() -> void:
	var i:int = 1
	var tweens:Array = [create_tween(), create_tween(), create_tween(), create_tween()]
	
	for el in bg_arr:
		@warning_ignore("integer_division")
		tweens[i - 1].tween_property(el, "position:y", int(el.position.y * 1.0 + par_var / i), 0.6)
		tweens[i - 1].set_ease(Tween.EASE_IN)
		tweens[i - 1].set_trans(Tween.TRANS_SINE)
		tweens[i - 1].play()
		i += 1

func _move_game() -> void:
	timestamp_endgame = HUD.get_time()
	var tween = self.create_tween()
	tween.tween_property(%Game, "position:x", %Game.position.x - 530, 1.8)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.play()
	var ptween = self.create_tween()
	ptween.tween_property(%ash, "position", Vector2(%ash.position.x + 420, %ash.position.y + 230), 10)
	ptween.parallel().tween_property(%ash, "scale", Vector2(0.01, 0.01), 10)
	ptween.set_ease(Tween.EASE_OUT)
	ptween.set_trans(Tween.TRANS_SINE)
	ptween.play()
	$AnimationPlayer.play("game_end")
	HUD.queue_free()
	HUD = null
	$Timer.start()

func _on_ash_got_hit():
	$Node/spine.play()

func _on_fire_finished():
	$Node/fire.play()

func _on_ash_death_signal():
	$Node/death.play()
	HUD.get_lives(player.lives)

func _on_ash_respawn_signal():
	%ash.position = self.last_checkpoint

func _on_ash_game_over():
	self.get_tree().change_scene_to_file("res://src/UI/title_screen.tscn")

var timestamp_endgame:String

func _game_end_game():
	$DialogueControl2.process_mode = Node.PROCESS_MODE_INHERIT
	var dia = "There is always 
	a first time
	.  .  .
	even if it is 
	the last one"
	$DialogueControl2._play(dia)
	$DialogueControl2.visible = true

var inte:int = 0

func _on_dialogue_control_2_exited():
	print("hi")
	if inte == 0:
		$DialogueControl2.process_mode = Node.PROCESS_MODE_INHERIT
		var dia = "Congratulations
		time:
		"
		dia += timestamp_endgame
		$DialogueControl2._play(dia)
		$DialogueControl2.visible = true
		inte = 1
	else:
		get_tree().change_scene_to_file("res://src/Credits.tscn")
