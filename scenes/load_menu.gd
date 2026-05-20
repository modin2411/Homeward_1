extends Node2D

@onready var saves_label = $Control/Panel/MarginContainer/VBoxContainer/saves
@onready var nosave_label = $Control/Panel/MarginContainer/VBoxContainer/nosave
@onready var savegame_list = $Control/Panel/MarginContainer/VBoxContainer/ScrollContainer/SavegameList

@onready var start_button = $Control/Panel/MarginContainer/VBoxContainer/StartButton
@onready var delete_button = $Control/Panel/MarginContainer/VBoxContainer/DeleteButton

var selected_slot: String = ""


func _ready() -> void:
	start_button.disabled = true
	delete_button.disabled = true

	build_save_list()


func build_save_list() -> void:
	for child in savegame_list.get_children():
		child.queue_free()

	var saves: Array = SaveManager.get_all_save_slots()

	if saves.is_empty():
		nosave_label.visible = true
		return

	nosave_label.visible = false

	for save_slot in saves:
		var button := Button.new()

		var slot_name: String = str(save_slot.get("slot_name", "Unbekannt"))
		var updated_at: String = str(
			save_slot.get("updated_at", "")
		).replace("T", " um ")

		button.text = slot_name + "\nZuletzt gespeichert: " + updated_at

		button.custom_minimum_size = Vector2(0, 70)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.toggle_mode = true

		button.pressed.connect(_on_save_slot_selected.bind(slot_name, button))

		savegame_list.add_child(button)


func _on_save_slot_selected(slot_name: String, pressed_button: Button) -> void:
	selected_slot = slot_name

	start_button.disabled = false
	delete_button.disabled = false

	# Andere Buttons abwählen
	for child in savegame_list.get_children():
		if child is Button and child != pressed_button:
			child.button_pressed = false


func _on_start_button_pressed() -> void:
	if selected_slot == "":
		return

	var data: Dictionary = SaveManager.load_game(selected_slot)

	if data.is_empty():
		return

	if not data.has("scene") or not data.has("position") or not data.has("game_manager"):
		return

	var scene_path: String = str(data["scene"])
	var pos_dict: Dictionary = data["position"]
	var gm_data: Dictionary = data["game_manager"]

	SaveManager.apply_game_manager_data(gm_data)

	SaveManager.pending_player_position = Vector2(
		float(pos_dict.get("x", 0.0)),
		float(pos_dict.get("y", 0.0))
	)

	SaveManager.has_pending_player_position = true

	get_tree().change_scene_to_file(scene_path)


func _on_delete_button_pressed() -> void:
	if selected_slot == "":
		return

	SaveManager.delete_save(selected_slot)

	selected_slot = ""

	start_button.disabled = true
	delete_button.disabled = true

	build_save_list()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_Menu.tscn")
