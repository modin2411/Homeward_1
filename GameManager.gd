extends Node

var coins: int = 0
var apple: int = 0
var ring: int = 0
var medikit: int = 0
var diamant: int = 0
var stick: int = 0
var health: int = 3
var max_health: int = 3

var quest_progress: int = 0
var quest_progress_max: int = 100

var inventory_data: Array = []

# 👉 Torgue Counter (wie Coins)
var torgue: int = 0

func _process(_delta):
	print(apple)#kontrolle für verschieden items
	print(medikit)
	


func damage(amount: int = 1):
	health -= amount
	if health < 0:
		health = 0


func heal(amount: int = 1):
	health += amount
	if health > max_health:
		health = max_health


func can_buy_heart() -> bool:
	return coins >= 5 and health < max_health


func buy_heart():
	if can_buy_heart():
		coins -= 5
		heal(1)


func add_quest_progress(amount: int):
	quest_progress = clamp(quest_progress + amount, 0, quest_progress_max)


func reset_for_new_game() -> void:
	coins = 0
	apple = 0
	health = 3
	max_health = 3
	torgue = 0
	quest_progress = 0
	quest_progress_max = 100
	inventory_data.clear()
