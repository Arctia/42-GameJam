extends Control

@onready var player:Object = %ash
@onready var HUD:Object = %HUD

var level = 0

var intermezzi:Dictionary = {
	1: "There's always a first time
	to move around.",
	2: "There's always a first time
	to being stitched.",
	6: "There's always a first time
	to ..."
} 

func _ready():
	_to_new_level(3)

func _process(_dt):
	HUD.get_lives(player.lives)
	HUD.get_ashes(player.ashes_amount)

func _raise_level():
	level += 1
	if level in intermezzi: $DialogueControl._play(intermezzi[level])

# ---------------------------------------------------------------------------- #
# --- New Level Logic

func _to_new_level(how_many:int=1) -> void:
	%ash.position.y -= 8
	print("Tween production")
	var tween = self.create_tween()
	tween.tween_property(%Game, "position:y", %Game.position.y + (14 * 32) * how_many, 0.6)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.play()
	_raise_level()

