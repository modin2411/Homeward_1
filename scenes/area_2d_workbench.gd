extends Area2D
var player_in_range = false
var opened = false


@export var coin_scene: PackedScene

@onready var message_label = $"../diamantlabel"

func _ready():
	message_label.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		message_label.visible = true
		update_text()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		message_label.visible = false

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		drop_diamant()

func update_text():
	if opened:
		message_label.text = "You already got a diamantring"
	elif GameManager.diamant >= 1:
		message_label.text = "Press E to make the special Diamantring"
	else:
		message_label.text = "You need a diamant"

func drop_diamant():
	if opened:
		message_label.text = "You already got a diamantring"
		return

	if GameManager.apple < 1:
		message_label.text = "You need a diamant"
		return

	GameManager.diamant -= 1
	
	opened = true
	message_label.text = "You got the special diamantring"

	GameManager.add_quest_progress(1)
	get_tree().call_group("quest_ui", "update_quest_bar")

	spawn_ring()

func spawn_ring():
	var item_scenes: Array = [coin_scene]

	for scene in item_scenes:
		var item = scene.instantiate()
		get_tree().current_scene.add_child(item)

		item.global_position = global_position + Vector2(
			randf_range(0,3),
			randf_range(50,55)
		)
