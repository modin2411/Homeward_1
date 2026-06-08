extends CharacterBody2D

const SPEED = 40.0
const JUMP_VELOCITY = -400.0

var direction := 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = direction * SPEED

	move_and_slide()
	check_player_collision()
	
	# change sprite direction
	if direction > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func _on_timer_timeout():
	direction *= -1


func check_player_collision():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body != null and body.is_in_group("Player"):
			body.take_damage(1)


func _on_coin_body_entered(body: Node2D) -> void:
	pass
