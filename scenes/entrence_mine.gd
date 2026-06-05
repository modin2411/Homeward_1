extends Area2D

@export var JAR_scene: String = "res://scenes/worldjar.tscn"

@onready var label = $JARLabel

var player_ref = null


func _ready():
	label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	print("ENTERED")

	if body.is_in_group("player"):
		player_ref = body
		label.visible = true

		if has_ring():
			label.text = "Press E to enter"
		else:
			label.text = "Your true powers have not awakened yet ..."


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_ref = null
		label.visible = false


func _process(_delta):
	if player_ref == null:
		return

	if Input.is_action_just_pressed("interact"):

		if has_ring():
			get_tree().change_scene_to_file(JAR_scene)
			print("ENTER CAVE")
		else:
			label.text = "Perhaps a special ring could awaken them..."


func has_ring() -> bool:
	return GameManager.ring > 0
