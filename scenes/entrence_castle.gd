extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var label = $Label
@onready var bridge_collision = $StaticBody2D/CollisionShape2D

var player_in_area = false

func _ready() -> void:
	label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		player_in_area = true
		label.text = "Drücke E"
		label.visible = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_area = false
		label.visible = false

func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interact"):
		animated_sprite.play("default")
		label.visible = false

		await get_tree().create_timer(1).timeout

		bridge_collision.disabled = true
