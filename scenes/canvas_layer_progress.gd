extends CanvasLayer

@onready var quest_bar = $quest_bar

func _ready():
	add_to_group("quest_ui")
	update_quest_bar()

func update_quest_bar():
	quest_bar.max_value = GameManager.quest_progress_max
	quest_bar.value = GameManager.quest_progress
