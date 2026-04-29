extends Node2D


func _ready() -> void:
	var has_data := SaveManager.has_save("MySave")
	print("Save vorhanden im MainMenu: ", has_data)
	$button_controler/VBoxContainer/load.disabled = not has_data


func _on_start_pressed() -> void:
	GameManager.reset_for_new_game()
	SaveManager.has_pending_player_position = false
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_load_pressed() -> void:
	var data := SaveManager.load_game("MySave")

	if data.is_empty():
		print("Kein Save gefunden.")
		return

	if not data.has("scene") or not data.has("position") or not data.has("game_manager"):
		print("Save ist unvollständig.")
		return

	var scene_path: String = data["scene"]
	var pos_dict: Dictionary = data["position"]
	var gm_data: Dictionary = data["game_manager"]

	SaveManager.apply_game_manager_data(gm_data)
	SaveManager.pending_player_position = Vector2(pos_dict["x"], pos_dict["y"])
	SaveManager.has_pending_player_position = true

	get_tree().change_scene_to_file(scene_path)
