extends CharacterBody2D

const speed = 100
var current_dir = "down"
var is_dead = false
var is_hurt = false
var is_healing = false

var light_on := false

@export var inv: Inv

@onready var coin_label = $CanvasLayer/CoinLabel
@onready var quest_bar = $CanvasLayer_progress/quest_bar
@onready var heart1 = $CanvasLayer2/health
@onready var heart2 = $CanvasLayer2/health2
@onready var heart3 = $CanvasLayer2/health3

@onready var player_light = $PointLight2D2


func add_coin():
	GameManager.coins += 1
	update_coin_ui()


func add_apple():
	GameManager.apple += 1
	update_coin_ui()
	sync_inventory_to_game_manager()

func add_diamant():
	GameManager.diamant += 1
	sync_inventory_to_game_manager()
	
func add_ring():
	GameManager.ring += 1
	sync_inventory_to_game_manager()
	
func add_medikit():
	GameManager.medikit += 1
	sync_inventory_to_game_manager()
	
func add_stick():
	GameManager.stick += 1
	sync_inventory_to_game_manager()
	
func update_coin_ui():
	coin_label.text = str(GameManager.coins)


func update_hearts():
	heart1.visible = GameManager.health >= 1
	heart2.visible = GameManager.health >= 2
	heart3.visible = GameManager.health >= 3


func update_quest_bar():
	quest_bar.max_value = GameManager.quest_progress_max
	quest_bar.value = GameManager.quest_progress


func play_hurt_animation():
	if is_hurt or is_dead:
		return

	is_hurt = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("get_damage")


func die():
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	GameManager.coins = max(GameManager.coins - 10, 0)
	$AnimatedSprite2D.play("death")


func play_heal_animation():
	if is_dead or is_hurt or is_healing:
		return

	is_healing = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("get_heal")
	#GameManager.add_quest_progress(50)
	#update_quest_bar()


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		GameManager.health = GameManager.max_health
		get_tree().reload_current_scene()

	elif $AnimatedSprite2D.animation == "get_damage":
		is_hurt = false

	elif $AnimatedSprite2D.animation == "get_heal":
		is_healing = false


func sync_inventory_to_game_manager() -> void:
	if inv == null:
		GameManager.inventory_data = []
		return

	var result: Array = []

	for slot in inv.items:
		if slot == null or slot.item == null:
			continue

		result.append({
			"item_name": slot.item.name,
			"item_path": slot.item.resource_path,
			"amount": slot.amount
		})

	GameManager.inventory_data = result
	print("SYNC INVENTORY TO GM:", GameManager.inventory_data)


func rebuild_inventory_from_game_manager() -> void:
	if inv == null:
		return

	inv.items.clear()

	for entry in GameManager.inventory_data:
		if typeof(entry) != TYPE_DICTIONARY:
			continue

		var item_path: String = str(entry.get("item_path", ""))
		var amount: int = int(entry.get("amount", 1))

		if item_path.is_empty():
			push_error("Leerer item_path im GameManager-Inventar gefunden.")
			continue

		var loaded_item = load(item_path)
		if loaded_item == null:
			push_error("Item konnte nicht geladen werden: " + item_path)
			continue

		var new_slot := InvSlot.new()
		new_slot.item = loaded_item
		new_slot.amount = amount
		inv.items.append(new_slot)

	print("REBUILD INVENTORY FROM GM:", GameManager.inventory_data)
	get_tree().call_group("inventory_ui", "update_slots")


func _ready() -> void:
	add_to_group("player")
	$AnimatedSprite2D.play("front_idle")

	player_light.visible = false

	if SaveManager.has_pending_player_position:
		global_position = SaveManager.pending_player_position
		SaveManager.has_pending_player_position = false
		print("Geladene Position gesetzt: ", global_position)

	rebuild_inventory_from_game_manager()

	update_coin_ui()
	update_hearts()

	quest_bar.min_value = 0
	quest_bar.custom_minimum_size = Vector2(100, 24)
	update_quest_bar()


func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_I:
		var current_scene_path = get_tree().current_scene.scene_file_path
		var allowed_scene = "res://scenes/cave.tscn"

		if current_scene_path == allowed_scene:
			light_on = !light_on
			player_light.visible = light_on
		else:
			light_on = false
			player_light.visible = false


func _physics_process(_delta: float) -> void:
	if get_tree().paused:
		return

	if is_dead:
		return

	if is_hurt or is_healing:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	player_movement()


func player_movement():
	var input_dir = Vector2.ZERO

	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var down = Input.is_action_pressed("ui_down")
	var up = Input.is_action_pressed("ui_up")

	if right:
		input_dir.x += 1
	if left:
		input_dir.x -= 1
	if down:
		input_dir.y += 1
	if up:
		input_dir.y -= 1

	input_dir = input_dir.normalized()
	velocity = input_dir * speed

	if input_dir != Vector2.ZERO:
		match current_dir:
			"right":
				if not right:
					if left:
						current_dir = "left"
					elif down:
						current_dir = "down"
					elif up:
						current_dir = "up"

			"left":
				if not left:
					if right:
						current_dir = "right"
					elif down:
						current_dir = "down"
					elif up:
						current_dir = "up"

			"down":
				if not down:
					if up:
						current_dir = "up"
					elif right:
						current_dir = "right"
					elif left:
						current_dir = "left"

			"up":
				if not up:
					if down:
						current_dir = "down"
					elif right:
						current_dir = "right"
					elif left:
						current_dir = "left"

		play_anim(1)
	else:
		play_anim(0)

	move_and_slide()


func play_anim(movement):
	if is_dead or is_hurt or is_healing:
		return

	var anim = $AnimatedSprite2D

	if current_dir == "right":
		anim.flip_h = true
		anim.play("side_walk" if movement else "front_idle")

	elif current_dir == "left":
		anim.flip_h = false
		anim.play("side_walk" if movement else "front_idle")

	elif current_dir == "down":
		anim.flip_h = false
		anim.play("front_walk" if movement else "front_idle")

	elif current_dir == "up":
		anim.flip_h = false
		anim.play("back_walk" if movement else "front_idle")


func collect(item):
	inv.insert(item)
	sync_inventory_to_game_manager()
	get_tree().call_group("inventory_ui", "update_slots")
