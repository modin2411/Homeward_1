extends Area2D

@onready var label = $Label

var player_in_range := false

func _ready():
	label.visible = false
	label.text = "E to open"

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		label.visible = true
		

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		label.visible = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/world.tscn")
