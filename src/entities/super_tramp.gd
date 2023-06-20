extends Area2D

func activate() -> void:
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("default")
	$Sprite2D.visible = false

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.stop()
	$Sprite2D.visible = true
