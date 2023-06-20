extends Control

@onready var player:Object = %ash
@onready var HUD:Object = %HUD

func _process(dt):
	HUD.get_lives(player.lives)
	HUD.get_ashes(player.ashes_amount)
