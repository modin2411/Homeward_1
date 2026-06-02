extends Area2D

var player_in_range = false
var opened = false

@export var stick_scene: PackedScene

@onready var message_label = $"../logtosticklabel"

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
		trade_log_to_sticks()

func update_text():
	if GameManager.log < 1:
		message_label.text = "You need 1 log"
	else:
		message_label.text = "Press E to trade 1 log for 4 sticks"

func trade_log_to_sticks():
	if GameManager.log < 1:
		message_label.text = "You need 1 log"
		return

	GameManager.log -= 1
	GameManager.stick += 4

	message_label.text = "You got 4 sticks!"

	GameManager.add_quest_progress(1)
	get_tree().call_group("quest_ui", "update_quest_bar")

	spawn_sticks()

func spawn_sticks():
	for i in range(4):
		var item = stick_scene.instantiate()
		get_tree().current_scene.add_child(item)

		item.global_position = global_position + Vector2(
			randf_range(80, 90),
			randf_range(10, 20)
		)
