extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var label = $Label
@onready var bridge_collision = $StaticBody2D/CollisionShape2D

var player_in_area = false
var bridge_open = false

func _ready() -> void:
	label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		player_in_area = true
		label.visible = true
		update_label()

func _on_body_exited(body) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		label.visible = false

func _process(_delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interact"):
		try_open_bridge()

func update_label() -> void:
	if bridge_open:
		label.text = "Die Schlossbrücke ist bereits unten"
	elif has_ring():
		label.text = "Drücke E, um die Schlossbrücke herunterzulassen"
	else:
		label.text = "Du brauchst den Ring"

func try_open_bridge() -> void:
	if bridge_open:
		label.text = "Die Schlossbrücke ist bereits unten"
		return

	if not has_ring():
		label.text = "Du brauchst den Ring"
		return

	bridge_open = true
	label.text = "Die Schlossbrücke wird heruntergelassen"
	animated_sprite.play("bridge")

	await get_tree().create_timer(1.0).timeout

	bridge_collision.set_deferred("disabled", true)
	label.visible = false

func has_ring() -> bool:
	return GameManager.ring > 0
