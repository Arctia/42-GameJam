extends Area2D

func _on_body_entered(body):
	if "ash" in body.name:
		body.world_fric /= 20. 

func _on_body_exited(body):
	if "ash" in body.name:
		body.world_fric = body.FRICTION 

