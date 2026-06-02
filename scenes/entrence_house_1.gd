extends Area2D

@onready var label = $Label
var player_ref: Node2D = null
var player_in_range := false


func _ready():
	label.visible = false
	label.text = "Press E to enter"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		player_ref = body
		label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		player_ref = null
		label.visible = false

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		GameManager.return_position = player_ref.global_position
		GameManager.has_return_position = true
		get_tree().change_scene_to_file("res://scenes/house_1.tscn")
