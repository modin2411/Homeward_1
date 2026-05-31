extends Area2D

@onready var light = $"1_light"

func _ready():
	light.enabled = false

func _on_body_entered(body):
	light.enabled = true

func _on_body_exited(body):
	light.enabled = false
