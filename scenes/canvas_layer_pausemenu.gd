extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_resume_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	
func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")
	
func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_Menu.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()
