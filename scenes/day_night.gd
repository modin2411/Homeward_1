extends CanvasModulate

var time := 0.0
var speed := 0.01  # langsam

func _process(delta):
	time += delta * speed

	var value = (sin(time) + 1.0) / 2.0

	
	color = Color(
		0.05 + value * 0.95,   # R
		0.05 + value * 0.95,   # G
		0.1  + value * 0.9     # B
	)
