extends Control

@onready var player:Object = %ash
@onready var HUD:Object = %HUD

var level = 0

var intermezzi:Dictionary = {
	1: "There's always a first time
	to move around.",
	2: "There's always a first time
	to being stitched.",
	5: "There's always a first time
	to ..."
} 

func _ready():
	_to_new_level(4)
	pass

func _process(_dt):
	HUD.get_lives(player.lives)
	HUD.get_ashes(player.ashes_amount)

func _raise_level():
	level += 1
	if level in intermezzi: 
		$DialogueControl._play(intermezzi[level])
		self.get_tree().paused = true

# ---------------------------------------------------------------------------- #
# --- New Level Logic

func _to_new_level(how_many:int=1) -> void:
	%ash.position.y -= 40
	print("Tween production")
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

@onready var bg_arr = [%Sprite2D, %Sprite2D2, %Sprite2D3, %Sprite2D4]
@export var par_var = 15

func _move_background() -> void:
	var i:int = 1
	var tweens:Array = [create_tween(), create_tween(), create_tween(), create_tween()]
	
	for el in bg_arr:
		tweens[i - 1].tween_property(el, "position:y", el.position.y + par_var / i, 0.6)
		tweens[i - 1].set_ease(Tween.EASE_IN)
		tweens[i - 1].set_trans(Tween.TRANS_SINE)
		tweens[i - 1].play()
		i += 1

func _on_ash_got_hit():
	$Node/spine.play()
