extends CharacterBody2D

const speed = 100
var current_dir = "down"

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement()

func player_movement():
	var input_dir = Vector2.ZERO
	
	var right = Input.is_action_pressed("ui_right")
	var left  = Input.is_action_pressed("ui_left")
	var down  = Input.is_action_pressed("ui_down")
	var up    = Input.is_action_pressed("ui_up")
	
	# Bewegungsrichtung (mehrere gleichzeitig möglich)
	if right: input_dir.x += 1
	if left:  input_dir.x -= 1
	if down:  input_dir.y += 1
	if up:    input_dir.y -= 1
	
	input_dir = input_dir.normalized()
	velocity = input_dir * speed
	
	# Blickrichtung NUR ändern, wenn aktuelle Richtung losgelassen wurde
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
		
		
		
var hearts_list : Array[TextureRect]
var health = 3

func _ready() -> void:
	var hearts_parent = $heartbar/HBoxContainer
	for child in hearts_parent.get_children():
		hearts_list.appand(child)
	print(heart_list)
