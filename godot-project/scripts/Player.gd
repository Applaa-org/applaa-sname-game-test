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
	
	# Handle movement with better input detection
	var direction := Vector2.ZERO
	
	# Check for left/right movement
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction.x -= 1.0
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction.x += 1.0
	
	# Check for up/down movement
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		direction.y -= 1.0
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		direction.y += 1.0
	
	# Normalize diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Apply movement
	velocity = direction * SPEED
	
	# Move and clamp to screen bounds
	move_and_slide()
	
	position.x = clamp(position.x, 30, 770)
	position.y = clamp(position.y, 30, 570)
	
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