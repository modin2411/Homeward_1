extends CharacterBody2D

const speed = 100
var current_dir = "down"
var is_dead = false
var is_hurt = false
var is_healing = false

@onready var coin_label = $CanvasLayer/CoinLabel

@onready var heart1 = $CanvasLayer2/health
@onready var heart2 = $CanvasLayer2/health2
@onready var heart3 = $CanvasLayer2/health3

func add_coin():
	GameManager.coins += 1
	update_coin_ui()

func update_coin_ui():
	coin_label.text = str(GameManager.coins)
	
func update_hearts():
	heart1.visible = GameManager.health >= 1
	heart2.visible = GameManager.health >= 2
	heart3.visible = GameManager.health >= 3

func play_hurt_animation():
	if is_hurt or is_dead:
		return
	
	is_hurt = true
	$AnimatedSprite2D.play("get_damage")	

func die():
	if is_dead:
		return
	
	is_dead = true
	velocity = Vector2.ZERO
	GameManager.coins -= 10
	$AnimatedSprite2D.play("death")

func play_heal_animation():
	if is_dead or is_hurt or is_healing:
		return

	is_healing = true
	$AnimatedSprite2D.play("get_heal")


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		GameManager.health = GameManager.max_health
		get_tree().reload_current_scene()
	
	elif $AnimatedSprite2D.animation == "get_damage":
		is_hurt = false
		
	elif $AnimatedSprite2D.animation == "get_heal":
		is_healing = false
		
func _ready():
	add_to_group("player")
	$AnimatedSprite2D.play("front_idle")
	update_coin_ui()
	update_hearts()

func _physics_process(delta):
	if is_dead:
		return
	
	if is_hurt or is_healing:
		move_and_slide()
		return
	
	player_movement()

func player_movement():
	var input_dir = Vector2.ZERO
	
	var right = Input.is_action_pressed("ui_right")
	var left  = Input.is_action_pressed("ui_left")
	var down  = Input.is_action_pressed("ui_down")
	var up    = Input.is_action_pressed("ui_up")
	
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
