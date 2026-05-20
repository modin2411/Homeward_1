extends Node2D

@onready var load_button = $button_controler/VBoxContainer/load
@onready var new_game_name_panel = $NewGameNamePanel
@onready var name_line_edit = $NewGameNamePanel/Panel/VBoxContainer/NameLineEdit
@onready var error_label = $NewGameNamePanel/Panel/VBoxContainer/ErrorLabel


func _ready() -> void:
	load_button.disabled = not SaveManager.has_any_save()
	new_game_name_panel.visible = false
	error_label.visible = false


func _on_start_pressed() -> void:
	new_game_name_panel.visible = true
	error_label.visible = false
	name_line_edit.text = ""
	name_line_edit.grab_focus()


func _on_confirm_new_game_button_pressed() -> void:
	var slot_name: String = name_line_edit.text.strip_edges()

	if slot_name.is_empty():
		error_label.visible = true
		error_label.text = "No name entered."
		return

	if SaveManager.create_new_game(slot_name):
		SaveManager.has_pending_player_position = false
		get_tree().change_scene_to_file("res://scenes/world.tscn")
	else:
		error_label.visible = true
		error_label.text = "This name already exists."


func _on_cancel_new_game_button_pressed() -> void:
	new_game_name_panel.visible = false


func _on_load_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/load_menu.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
