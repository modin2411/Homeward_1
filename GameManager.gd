extends Node

var coins: int = 0
var health: int = 3
var max_health: int = 3

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
