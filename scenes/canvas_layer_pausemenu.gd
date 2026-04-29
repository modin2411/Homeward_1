extends CanvasLayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	add_to_group("pause_menu")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("PauseMenu"):
		if visible:
			close_pause_menu()
		else:
			open_pause_menu()

		get_viewport().set_input_as_handled()


func open_pause_menu() -> void:
	visible = true
	get_tree().paused = true


func close_pause_menu() -> void:
	visible = false
	get_tree().paused = false


func _on_resume_pressed() -> void:
	close_pause_menu()


func _on_controls_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Main_Menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_save_pressed() -> void:
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		push_error("Kein Spieler in Gruppe 'player' gefunden.")
		return

	var current_scene = get_tree().current_scene
	if current_scene == null:
		push_error("Keine aktuelle Szene gefunden.")
		return

	var ok := SaveManager.save_game(
		"MySave",
		player.global_position,
		current_scene.scene_file_path,
		player.inv
	)

	if ok:
		print("Spiel gespeichert.")
	else:
		print("Speichern fehlgeschlagen.")
