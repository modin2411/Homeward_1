extends CharacterBody2D

const speed = 100
var current_dir = "down"


@onready var coin_label = $CanvasLayer/CoinLabel

func add_coin():
	CoinManager.coins += 1
	print("Coins:", CoinManager.coins)
	update_coin_ui()

func update_coin_ui():
	print("UI update:", CoinManager.coins)
	coin_label.text = str(CoinManager.coins)
	

func _ready():
	$AnimatedSprite2D.play("front_idle")
	update_coin_ui()

	

func _physics_process(delta):
	player_movement()


func player_movement():
	var input_dir = Vector2.ZERO
	
	var right = Input.is_action_pressed("ui_right")
	var left  = Input.is_action_pressed("ui_left")
	var down  = Input.is_action_pressed("ui_down")
	var up    = Input.is_action_pressed("ui_up")
	
	if right: input_dir.x += 1
	if left:  input_dir.x -= 1
	if down:  input_dir.y += 1
	if up:    input_dir.y -= 1
	
	input_dir = input_dir.normalized()
	velocity = input_dir * speed
	
	if input_dir != Vector2.ZERO:
		
		match current_dir:
			"right":
				if not right:
					if left: current_dir = "left"
					elif down: current_dir = "down"
					elif up: current_dir = "up"
			
			"left":
				if not left:
					if right: current_dir = "right"
					elif down: current_dir = "down"
					elif up: current_dir = "up"
			
			"down":
				if not down:
					if up: current_dir = "up"
					elif right: current_dir = "right"
					elif left: current_dir = "left"
			
			"up":
				if not up:
					if down: current_dir = "down"
					elif right: current_dir = "right"
					elif left: current_dir = "left"
		
		play_anim(1)
	else:
		play_anim(0)

	move_and_slide()


func play_anim(movement):
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
