extends Node2D

@onready var player = $player

func _ready():
	if GameManager.has_return_position:
		player.global_position = GameManager.return_position
		GameManager.has_return_position = false
