extends Node

const SAVE_PATH := "user://savegames.json"

var save_data: Dictionary = {}
var pending_player_position: Vector2 = Vector2.ZERO
var has_pending_player_position := false
var current_slot_name: String = ""


func _ready() -> void:
	load_file()


func load_file() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		save_data = {
			"saves": {}
		}
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		save_data = {
			"saves": {}
		}
		push_error("Save-Datei konnte nicht geöffnet werden.")
		return

	var text := file.get_as_text()
	if text.is_empty():
		save_data = {
			"saves": {}
		}
		return

	var parsed = JSON.parse_string(text)
	if typeof(parsed) == TYPE_DICTIONARY:
		save_data = parsed
		if not save_data.has("saves"):
			save_data["saves"] = {}
	else:
		save_data = {
			"saves": {}
		}
		push_error("Save-Datei ist ungültig.")


func write_file() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Save-Datei konnte nicht geschrieben werden.")
		return false

	file.store_string(JSON.stringify(save_data, "\t"))
	return true


func get_game_manager_data() -> Dictionary:
	return {
		"coins": GameManager.coins,
		"apple": GameManager.apple,
		"ring": GameManager.ring,
		"medikit": GameManager.medikit,
		"diamant": GameManager.diamant,
		"stick": GameManager.stick,
		"torgue": GameManager.torgue,
		"health": GameManager.health,
		"max_health": GameManager.max_health,
		"quest_progress": GameManager.quest_progress,
		"quest_progress_max": GameManager.quest_progress_max,
		"inventory": GameManager.inventory_data
	}


func apply_game_manager_data(data: Dictionary) -> void:
	GameManager.coins = int(data.get("coins", 0))
	GameManager.apple = int(data.get("apple", 0))
	GameManager.ring = int(data.get("ring", 0))
	GameManager.medikit = int(data.get("medikit", 0))
	GameManager.diamant = int(data.get("diamant", 0))
	GameManager.stick = int(data.get("stick", 0))
	GameManager.torgue = int(data.get("torgue", 0))
	GameManager.max_health = int(data.get("max_health", 3))
	GameManager.health = clamp(int(data.get("health", 3)), 0, GameManager.max_health)
	GameManager.quest_progress_max = int(data.get("quest_progress_max", 100))
	GameManager.quest_progress = clamp(
		int(data.get("quest_progress", 0)),
		0,
		GameManager.quest_progress_max
	)

	if data.has("inventory"):
		GameManager.inventory_data = data["inventory"]
	else:
		GameManager.inventory_data = []


func create_new_game(slot_name: String) -> bool:
	load_file()

	slot_name = slot_name.strip_edges()
	if slot_name.is_empty():
		push_error("Slot-Name ist leer.")
		return false

	if save_data["saves"].has(slot_name):
		push_error("Savegame-Name existiert bereits.")
		return false

	current_slot_name = slot_name
	GameManager.reset_for_new_game()

	save_data["saves"][slot_name] = {
		"slot_name": slot_name,
		"created_at": Time.get_datetime_string_from_system(),
		"updated_at": Time.get_datetime_string_from_system(),
		"scene": "res://scenes/world.tscn",
		"position": {
			"x": 0,
			"y": 0
		},
		"game_manager": get_game_manager_data()
	}

	return write_file()


func save_game(slot_name: String, player_position: Vector2, scene_path: String) -> bool:
	load_file()

	if slot_name.strip_edges().is_empty():
		push_error("Kein Slot-Name gesetzt.")
		return false

	save_data["saves"][slot_name] = {
		"slot_name": slot_name,
		"created_at": save_data["saves"].get(slot_name, {}).get("created_at", Time.get_datetime_string_from_system()),
		"updated_at": Time.get_datetime_string_from_system(),
		"scene": scene_path,
		"position": {
			"x": player_position.x,
			"y": player_position.y
		},
		"game_manager": get_game_manager_data()
	}

	current_slot_name = slot_name
	return write_file()


func save_current_game(player_position: Vector2, scene_path: String) -> bool:
	if current_slot_name.is_empty():
		push_error("Es gibt keinen aktiven Save-Slot.")
		return false

	return save_game(current_slot_name, player_position, scene_path)


func load_game(slot_name: String) -> Dictionary:
	load_file()

	if not save_data.has("saves"):
		return {}

	if not save_data["saves"].has(slot_name):
		return {}

	var slot_data = save_data["saves"][slot_name]
	if typeof(slot_data) != TYPE_DICTIONARY:
		return {}

	current_slot_name = slot_name
	return slot_data


func get_all_save_slots() -> Array:
	load_file()

	var result: Array = []

	if not save_data.has("saves"):
		return result

	for slot_name in save_data["saves"].keys():
		var slot_data = save_data["saves"][slot_name]
		if typeof(slot_data) != TYPE_DICTIONARY:
			continue

		result.append(slot_data)

	result.sort_custom(func(a, b): return str(a.get("updated_at", "")) > str(b.get("updated_at", "")))
	return result


func has_any_save() -> bool:
	load_file()
	return save_data.has("saves") and save_data["saves"].size() > 0


func delete_save(slot_name: String) -> bool:
	load_file()

	if not save_data.has("saves"):
		return false

	if not save_data["saves"].has(slot_name):
		return false

	save_data["saves"].erase(slot_name)

	if current_slot_name == slot_name:
		current_slot_name = ""

	return write_file()
