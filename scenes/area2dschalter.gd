extends Area2D

var player_in_range = false

@onready var label = $"../Label_Schalter"
@onready var animation_player = $"../AnimatedSprite2D"

func _ready() -> void:
	label.visible = false

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		animation_player.play("schalter")

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true
		label.text = "press E"
		label.visible = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
		label.visible = false
