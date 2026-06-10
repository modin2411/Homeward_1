extends Area2D

@onready var animation_player = $AnimatedSprite2D
@onready var label = $Label

var player_in_area = false

func _ready() -> void:
	label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true
		label.text = "Drücke E"
		label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		label.visible = false

func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interact"):
		animation_player.play("default")
