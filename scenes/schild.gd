extends Area2D

@onready var message_label: Label = $SignUI
var player_inside := false


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		show_message()


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		hide_message()


# Diese Funktion kannst du auch in _process() rufen, falls du die Nachricht nur unter Bedingungen anzeigen willst
func show_message():
	if message_label:
		message_label.text = "Sammle 3 Medizin-Items, um deinen Freund zu retten!"
		message_label.visible = true


func hide_message():
	if message_label:
		message_label.visible = false
