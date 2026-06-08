extends CharacterBody2D

const SPEED = 110.0
const JUMP_VELOCITY = -300.0
const INVINCIBILITY_TIME = 1.5
const DEATH_TIME = 0.8

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coin_label = $CanvasLayer/CoinLabel
@onready var heart1 = $CanvasLayer2/health
@onready var heart2 = $CanvasLayer2/health2
@onready var heart3 = $CanvasLayer2/health3
@export var inv: Inv

var is_dead = false
var is_hurt = false
var is_invincible = false
var spawn_position: Vector2 = Vector2(114, 20)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var invincibility_timer: Timer

func _ready():
	add_to_group("Player")
	update_coin_ui()
	update_hearts()

	invincibility_timer = Timer.new()
	invincibility_timer.one_shot = true
	invincibility_timer.wait_time = INVINCIBILITY_TIME
	add_child(invincibility_timer)

	if not invincibility_timer.timeout.is_connected(_on_invincibility_timer_timeout):
		invincibility_timer.timeout.connect(_on_invincibility_timer_timeout)

func add_coin() -> void:
	GameManager.coins += 1
	update_coin_ui()

func update_coin_ui() -> void:
	coin_label.text = str(GameManager.coins)

func update_hearts() -> void:
	heart1.visible = GameManager.health >= 1
	heart2.visible = GameManager.health >= 2
	heart3.visible = GameManager.health >= 3

func take_damage(amount: int = 1) -> void:
	if is_dead or is_hurt or is_invincible:
		return

	GameManager.health -= amount
	update_hearts()

	is_invincible = true
	invincibility_timer.start()

	if GameManager.health <= 0:
		die()
	else:
		play_hurt_animation()

func play_hurt_animation() -> void:
	if is_hurt or is_dead:
		return

	is_hurt = true
	velocity = Vector2.ZERO
	animated_sprite_2d.play("take_damage")
	await animated_sprite_2d.animation_finished
	is_hurt = false

func die() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite_2d.play("death")
	await get_tree().create_timer(DEATH_TIME).timeout
	respawn()

func respawn() -> void:
	GameManager.health = GameManager.max_health
	update_hearts()

	velocity = Vector2.ZERO
	global_position = spawn_position

	is_dead = false
	is_hurt = false
	is_invincible = true
	invincibility_timer.start()

	animated_sprite_2d.play("idle")

func _on_invincibility_timer_timeout() -> void:
	is_invincible = false

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

func collect(item) -> void:
	inv.insert(item)
	sync_inventory_to_game_manager()
	get_tree().call_group("inventory_ui", "update_slots")

func _physics_process(delta):
	if is_dead:
		return

	if is_hurt:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_axis = Input.get_axis("ui_left", "ui_right")
	if input_axis:
		velocity.x = input_axis * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animations(input_axis)

func update_animations(input_axis):
	if is_hurt or is_dead:
		return

	if not is_on_floor():
		animated_sprite_2d.play("jump")
	elif input_axis != 0:
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
