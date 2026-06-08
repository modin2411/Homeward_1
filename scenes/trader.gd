extends Area2D
var player_in_range = false
var opened = false


@export var coin_scene: PackedScene

@onready var message_label = $"../Label"

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
		trade_apples()

func update_text():
	if opened:
		message_label.text = "You already got the torch"
	elif GameManager.stick >= 20:
		message_label.text = "Press E to trade 20 sticks for a torch"
	else:
		message_label.text = "You need 20 sticks"

func trade_apples():
	if opened:
		message_label.text = "You already got the torch"
		return

	if GameManager.stick < 20:
		message_label.text = "You need 20 sticks"
		return

	GameManager.stick -= 2
	
	opened = true
	message_label.text = "You got a torch"

	GameManager.add_quest_progress(1)
	get_tree().call_group("quest_ui", "update_quest_bar")

	spawn_torgue()

func spawn_torgue():
	var item_scenes: Array = [coin_scene]

	for scene in item_scenes:
		var item = scene.instantiate()
		get_tree().current_scene.add_child(item)

		item.global_position = global_position + Vector2(
			randf_range(10, 20),
			randf_range(10, 20)
		)
