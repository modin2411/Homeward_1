extends CanvasLayer

@onready var help_menu = $Control/CenterContainer/VBoxContainer
@onready var hint_text = $Control/CenterContainer/VBoxContainer/HintText

@export_multiline var default_text: String = """Hint:
-Embark on a journey through the world of Fox 
   and find your missing friend.

-Talk to the inhabitants to gather clues and 
   receive new tasks.

-Search boxes and chests to discover valuable rewards."""

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
