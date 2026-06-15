extends Area2D

@export var item: InvItem

func _on_body_entered(body: Node2D) -> void:
	print("Stick touched by:", body.name)
	if body.is_in_group("player"):
		body.add_stick()
		body.collect(item)
		print(GameManager.stick)
		queue_free()
