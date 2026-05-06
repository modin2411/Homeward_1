extends CharacterBody2D


func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.flip_h = false
