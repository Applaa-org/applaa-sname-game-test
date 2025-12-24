extends CharacterBody2D

const SPEED: float = 300.0
const SHOOT_COOLDOWN: float = 0.2

var can_shoot: bool = true
var shoot_timer: float = 0.0

@onready var bullet_scene = preload("res://scenes/Bullet.tscn")

func _ready():
	# Position at bottom center
	position = Vector2(400, 500)

func _physics_process(delta: float):
	# Handle shooting
	if not can_shoot:
		shoot_timer -= delta
		if shoot_timer <= 0:
			can_shoot = true
	
	if Input.is_action_pressed("ui_accept") and can_shoot:
		shoot()
	
	# Handle movement (WASD)
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	velocity = Vector2(direction_x, direction_y).normalized() * SPEED
	
	# Clamp to screen bounds (with margin)
	position.x = clamp(position.x + velocity.x * delta, 30, 770)
	position.y = clamp(position.y + velocity.y * delta, 30, 570)
	
	move_and_slide()
	
	queue_redraw()

func _draw():
	# Draw triangle (pointing up) with retro green color
	var points = PackedVector2Array([
		Vector2(0, -15),    # Top point
		Vector2(-12, 15),   # Bottom left
		Vector2(12, 15)     # Bottom right
	])
	draw_colored_polygon(points, Color(0.4, 1, 0.4))
	draw_polyline(points + PackedVector2Array([points[0]]), Color(0.2, 0.6, 0.2), 2.0)

func shoot():
	can_shoot = false
	shoot_timer = SHOOT_COOLDOWN
	
	var bullet = bullet_scene.instantiate()
	bullet.position = position + Vector2(0, -20)
	get_parent().add_child(bullet)

func take_damage():
	# Player hit - trigger defeat
	get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")