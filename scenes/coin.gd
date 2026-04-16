extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.add_coin()
		queue_free()

func _ready():
	$AnimatedSprite2D.play("Coinsspin")
