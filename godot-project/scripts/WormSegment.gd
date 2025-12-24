extends Area2D

var segment_index: int = 0
var worm_controller = null

func _ready():
	add_to_group("worm_segment")
	body_entered.connect(_on_body_entered)

func _draw():
	# Draw circle segment with retro style
	var color = Color(1, 0.3, 0.3) if segment_index == 0 else Color(0.9, 0.4, 0.4)
	draw_circle(Vector2.ZERO, 10, color)
	draw_arc(Vector2.ZERO, 10, 0, TAU, 16, Color(0.6, 0.2, 0.2), 2.0)

func take_damage():
	if worm_controller:
		worm_controller.segment_destroyed(self)

func _on_body_entered(body):
	if body.name == "Player":
		body.take_damage()