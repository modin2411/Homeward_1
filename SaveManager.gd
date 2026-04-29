extends Node

const SAVE_PATH := "user://savegame.json"

var save_data: Dictionary = {}
var pending_player_position: Vector2 = Vector2.ZERO
var has_pending_player_position := false
var pending_inventory_data: Array = []


func _ready() -> void:
	load_file()


func load_file() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		save_data = {}
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		save_data = {}
		push_error("Save-Datei konnte nicht geöffnet werden.")
		return

	var text := file.get_as_text()
	if text.is_empty():
		save_data = {}
		return

	var parsed = JSON.parse_string(text)
	if typeof(parsed) == TYPE_DICTIONARY:
		save_data = parsed
	else:
		save_data = {}
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
		"health": GameManager.health,
		"max_health": GameManager.max_health,
		"quest_progress": GameManager.quest_progress,
		"quest_progress_max": GameManager.quest_progress_max
	}


func apply_game_manager_data(data: Dictionary) -> void:
	GameManager.coins = int(data.get("coins", 0))
	GameManager.apple = int(data.get("apple", 0))
	GameManager.max_health = int(data.get("max_health", 3))
	GameManager.health = clamp(int(data.get("health", 3)), 0, GameManager.max_health)
	GameManager.quest_progress_max = int(data.get("quest_progress_max", 100))
	GameManager.quest_progress = clamp(
		int(data.get("quest_progress", 0)),
		0,
		GameManager.quest_progress_max
	)


func get_inventory_data(inv: Inv) -> Array:
	var result: Array = []

	if inv == null:
		return result

	for slot in inv.items:
		if slot == null or slot.item == null:
			continue

		result.append({
			"item_path": slot.item.resource_path,
			"amount": slot.amount
		})

	return result


func save_game(slot_name: String, player_position: Vector2, scene_path: String, inv: Inv) -> bool:
	save_data[slot_name] = {
		"scene": scene_path,
		"position": {
			"x": player_position.x,
			"y": player_position.y
		},
		"game_manager": get_game_manager_data(),
		"inventory": get_inventory_data(inv)
	}

	return write_file()


func load_game(slot_name: String) -> Dictionary:
	load_file()

	if not save_data.has(slot_name):
		return {}

	var slot_data = save_data[slot_name]
	if typeof(slot_data) != TYPE_DICTIONARY:
		return {}

	return slot_data


func has_save(slot_name: String) -> bool:
	load_file()
	return save_data.has(slot_name)
