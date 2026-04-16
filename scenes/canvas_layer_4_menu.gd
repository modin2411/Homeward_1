extends Node

@onready var help_menu = $ColorRect

func _ready():
	help_menu.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("HelpMenu"):
		help_menu.visible = !help_menu.visible
