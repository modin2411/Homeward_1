extends Area2D

@export var item: InvItem

func _on_body_entered(body: Node2D) -> void:
	print("Torgue touched by:", body.name)
	
	if body.is_in_group("player"):
		GameManager.torgue = 1
		print("Torgue wurde aufgenommen")
		body.collect(item)
		queue_free()
