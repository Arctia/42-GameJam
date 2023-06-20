extends Area2D

signal to_the_next_level

@export var active:bool = true

func _ready():
	if not active: 
		%no_turning_back.disabled = false
		$CollisionShape2D.disabled = true

func _physics_process(_dt):
	if active: player_touched()

func player_touched() -> void:
	if not has_overlapping_bodies(): return
	for body in get_overlapping_bodies():
		if body.name == "ash":
			if body.position.y - 32 > self.position.y:
				print("yeah")
				to_the_next_level.emit()
				$CollisionShape2D.disabled = true
				%no_turning_back.disabled = false
