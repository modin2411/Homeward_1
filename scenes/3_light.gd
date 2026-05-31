extends Area2D

@onready var light = $"3_light"


func _ready():
	light.enabled = false

	# wartet einen Physics-Frame, damit Overlaps korrekt sind
	await get_tree().physics_frame

	_update_light_state()


func _on_body_entered(body):
	if body.is_in_group("player"):
		_update_light_state()


func _on_body_exited(body):
	if body.is_in_group("player"):
		_update_light_state()


func _update_light_state():
	var player_inside := false

	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			player_inside = true
			break

	light.enabled = player_inside
