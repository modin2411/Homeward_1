extends Area2D

@export_multiline var sign_text: String = """


Welcome to the village...
Here you can trade with villagers, 
use maschine's to further process your resources.
Your path's will surely lead you here more often ."""

func get_hint_ui():
	var nodes = get_tree().get_nodes_in_group("hint_ui")
	if nodes.size() > 0:
		return nodes[0]
	return null

func _on_body_entered(body):
	if body.is_in_group("player"):
		var ui = get_hint_ui()
		if ui:
			ui.set_area_hint(sign_text)

func _on_body_exited(body):
	if body.is_in_group("player"):
		var ui = get_hint_ui()
		if ui:
			ui.clear_area_hint()
