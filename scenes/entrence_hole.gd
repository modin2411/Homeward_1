extends Area2D

@export var cave_scene: String = "res://scenes/cave.tscn"

@onready var label = $Cavelabel

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

		if has_torgue():
			label.text = "Press E to enter cave"
		else:
			label.text = "You need a torch"


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_ref = null
		label.visible = false


func _process(_delta):
	if player_ref == null:
		return

	if Input.is_action_just_pressed("interact"):

		if has_torgue():
			GameManager.return_position = player_ref.global_position
			GameManager.has_return_position = true
			get_tree().change_scene_to_file(cave_scene)
			print("ENTER CAVE")
		else:
			label.text = "It's too dark..."


func has_torgue() -> bool:
	return GameManager.torgue > 0
