extends StaticBody2D

var player_in_range = false
var opened = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hint_label: Label = $chest_massage

# 👉 mehrere Items möglich
@export var item_scenes: Array[PackedScene]

func _ready():
	hint_label.visible = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not opened:
		player_in_range = true
		hint_label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		hint_label.visible = false


func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		open_chest()


func open_chest():
	if opened:
		return
	
	opened = true
	hint_label.visible = false
	anim.play("open")

	# 👉 Items spawnen nach Animation
	spawn_items()


func spawn_items():
	if item_scenes.is_empty():
		print("Keine Items gesetzt!")
		return

	for scene in item_scenes:
		var item = scene.instantiate()
		get_tree().current_scene.add_child(item)

		# 👉 leicht random vor der Chest spawnen
		item.global_position = global_position + Vector2(
			randf_range(0, 10),
			randf_range(-10, -15)
		)
