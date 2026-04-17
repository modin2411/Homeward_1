extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		GameManager.damage(1)
		body.update_hearts()

		if GameManager.health <= 0:
			body.die()
		else:
			body.play_hurt_animation()
