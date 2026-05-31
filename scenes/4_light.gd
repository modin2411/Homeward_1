extends Area2D

@onready var light1 = $"4_light"
@onready var light2 = $"4_2light"


func _ready():
	# HARD RESET (wichtig!)
	light1.enabled = false
	light2.enabled = false

	# warten bis Physics stabil ist
	await get_tree().physics_frame

	# initial korrekt setzen (falls Spieler schon drin wäre)
	_update_light_state()


func _on_body_entered(body):
	if body.is_in_group("player"):
		_update_light_state()


func _on_body_exited(body):
	if body.is_in_group("player"):
		_update_light_state()


func _update_light_state():
	# nur an wenn wirklich ein Player drin ist
	var player_inside := false

	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			player_inside = true
			break

	light1.enabled = player_inside
	light2.enabled = player_inside
