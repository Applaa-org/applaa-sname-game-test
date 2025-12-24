extends Area2D

const SPEED: float = 400.0

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float):
	position.y -= SPEED * delta
	
	# Remove if off screen
	if position.y < -10:
		queue_free()
	
	queue_redraw()

func _draw():
	# Small rectangle bullet
	draw_rect(Rect2(-2, -6, 4, 12), Color(1, 1, 0.2))

func _on_body_entered(body):
	if body.is_in_group("worm_segment"):
		body.take_damage()
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("worm_segment"):
		area.get_parent().take_damage()
		queue_free()