extends Area2D

var player_in_range = false
var opened = false

@export var king_reward_scene: PackedScene
@onready var message_label = $"../Label"

func _ready() -> void:
	message_label.visible = false

func get_player():
	return get_tree().get_first_node_in_group("player")

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
		trade_with_king()

func update_text() -> void:
	var player = get_player()
	if player == null:
		return

	if opened:
		message_label.text = "You already traded with the king"
	elif GameManager.ring >= 1:
		message_label.text = "Press E to trade the ring with the king"
	else:
		message_label.text = "You need a special ring"

func trade_with_king() -> void:
	var player = get_player()
	if player == null:
		return

	if opened:
		message_label.text = "You already traded with the king"
		return

	if GameManager.ring < 1:
		message_label.text = "You need a special ring"
		return

	GameManager.ring -= 1
	player.inv.remove_items("ring", 1)

	opened = true
	message_label.text = "You got the king reward"

	GameManager.add_quest_progress(1)
	get_tree().call_group("quest_ui", "update_quest_bar")

	spawn_king_reward()

func spawn_king_reward() -> void:
	if king_reward_scene == null:
		return

	var item = king_reward_scene.instantiate()
	get_tree().current_scene.add_child(item)
	item.global_position = global_position + Vector2(
		randf_range(10, 20),
		randf_range(10, 20)
	)
