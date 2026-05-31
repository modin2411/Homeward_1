extends Area2D

@onready var collision_shape = $CollisionShape2D

var active := false

const ACTIVE_TIME := 2.0
const INACTIVE_TIME := 1.0
const CYCLE_TIME := ACTIVE_TIME + INACTIVE_TIME


func _ready():
	add_to_group("spikes")


func _process(_delta):
	var t = fmod(Time.get_ticks_msec() / 1000.0, CYCLE_TIME)

	if t < ACTIVE_TIME:
		active = true
		collision_shape.disabled = false
	else:
		active = false
		collision_shape.disabled = true


func _on_body_entered(body):
	if not active:
		return

	if body.is_in_group("player"):
		GameManager.damage(1)
		body.update_hearts()

		if GameManager.health <= 0:
			body.die()
		else:
			body.play_hurt_animation()
