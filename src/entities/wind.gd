@tool
extends Area2D

@export var force:int = 1

func _ready():
	$CPUParticles2D.gravity.x = 980 * self.force
