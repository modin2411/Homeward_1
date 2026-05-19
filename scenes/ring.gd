extends Area2D

@export var item: InvItem

func _ready():
	$AnimatedSprite2D.play("ringspin")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.add_coin()      # optional Counter
		body.collect(item)   # INS INVENTORY
		queue_free()
