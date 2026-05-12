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
	if GameManager.apple >= 2:
		message_label.text = "Press E to trade 2 apples for a torgue"
	else:
		message_label.text = "You need 2 apples"


func trade_apples():
	if opened:
		return

	if GameManager.apple < 2:
		message_label.text = "You need 2 apples"
		return

	GameManager.apple -= 2
	
	opened = true
	
	message_label.text = "You got a torgue"

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
