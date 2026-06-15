extends Area2D

var player_in_range = false

@export var coin_scene: PackedScene
@onready var message_label = $"../logtosticklabel"


func _ready():
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
		drop_stick()


func update_text():
	var player = get_player()
	if player == null:
		return

	if player.inv.get_item_count("Log") >= 1:
		message_label.text = "Press E to trade 1 log for 4 sticks"
	else:
		message_label.text = "You need a log"


func drop_stick():
	var player = get_player()
	if player == null:
		return

	if player.inv.get_item_count("Log") < 1:
		message_label.text = "You need a log"
		return

	# 1 LOG ABZIEHEN
	player.inv.remove_items("Log", 1)

	message_label.text = "You got 4 sticks!"

	GameManager.add_quest_progress(1)
	get_tree().call_group("quest_ui", "update_quest_bar")

	spawn_stick()


func spawn_stick():
	for i in range(4):
		var item = coin_scene.instantiate()
		get_tree().current_scene.add_child(item)

		item.global_position = global_position + Vector2(
			randf_range(80, 90),
			randf_range(10, 20)
		)
