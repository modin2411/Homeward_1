extends Area2D

var player_in_range = false
var player_ref = null

@onready var message_label = $"../../player/MeldungKaufenMünzen/MünzenfürCoins"

func _ready():
	message_label.visible = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		player_ref = body
		message_label.visible = true
		update_message()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		player_ref = null
		message_label.visible = false

func _process(_delta):
	if player_in_range:
		update_message()

		if Input.is_action_just_pressed("interact"):
			if GameManager.coins >= 5 and GameManager.health < GameManager.max_health:
				GameManager.coins -= 5
				GameManager.health += 1
				GameManager.health = min(GameManager.health, GameManager.max_health)

				if player_ref:
					player_ref.update_hearts()
					player_ref.update_coin_ui()

				message_label.text = "1 Herz gekauft!"
			elif GameManager.health >= GameManager.max_health:
				message_label.text = "Du hast schon volle Herzen"
			else:
				message_label.text = "Du brauchst 5 Münzen"

func update_message():
	if GameManager.health >= GameManager.max_health:
		message_label.text = "Du hast schon volle Herzen"
	elif GameManager.coins >= 5:
		message_label.text = "Drücke E: Kaufe 1 Herz für 5 Münzen"
	else:
		message_label.text = "Du brauchst 5 Münzen"
