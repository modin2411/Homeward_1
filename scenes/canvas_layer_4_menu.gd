extends CanvasLayer

@onready var help_menu = $Control/CenterContainer/VBoxContainer
@onready var hint_text = $Control/CenterContainer/VBoxContainer/HintText

@export_multiline var default_text: String = """Hinweiß.
-Begib dich auf eine Reise durch die Welt von Fox 
   und finde deinen vermissten Freund.
-Sprich mit den Bewohnern, um Hinweise zu sammeln 
   und neue Aufgaben zu erhalten.
-Durchsuche Boxen und Kisten, um wertvolle 
  Belohnungen zu entdecken.."""

var override_text: String = ""

func _ready():
	help_menu.visible = false
	hint_text.custom_minimum_size = Vector2(200, 40)
	hint_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_update_text()

func _process(_delta):
	if Input.is_action_just_pressed("HelpMenu"):
		if help_menu.visible:
			help_menu.visible = false
		else:
			_update_text()
			help_menu.visible = true

func set_area_hint(new_text: String) -> void:
	override_text = new_text
	_update_text()
	help_menu.visible = true

func clear_area_hint() -> void:
	override_text = ""
	help_menu.visible = false

func _update_text() -> void:
	if override_text != "":
		hint_text.text = override_text
	else:
		hint_text.text = default_text
