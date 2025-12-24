extends Node2D

const BASE_SEGMENT_COUNT: int = 10
const SEGMENT_SPACING: float = 20.0
const BASE_MOVE_SPEED: float = 50.0
const DIRECTION_CHANGE_TIME: float = 2.0

@onready var segment_scene = preload("res://scenes/WormSegment.tscn")

var segments: Array = []
var positions: Array = []
var direction: Vector2 = Vector2(1, 0)
var direction_timer: float = 0.0
var move_speed: float = BASE_MOVE_SPEED
var segment_count: int = BASE_SEGMENT_COUNT

func _ready():
	calculate_level_stats()
	spawn_worm()

func calculate_level_stats():
	# Increase difficulty based on level
	var level = Global.current_level
	segment_count = BASE_SEGMENT_COUNT + (level - 1) * 3  # More segments each level
	move_speed = BASE_MOVE_SPEED + (level - 1) * 15.0    # Faster each level
	segment_count = min(segment_count, 25)  # Cap at 25 segments
	move_speed = min(move_speed, 120.0)     # Cap speed

func spawn_worm():
	segments.clear()
	positions.clear()
	
	# Random starting position at top
	var start_x = randf_range(100, 700)
	var start_y = randf_range(50, 100)
	var start_pos = Vector2(start_x, start_y)
	
	# Random starting direction
	var angle = randf_range(-PI/4, PI/4)  # Generally downward
	direction = Vector2(cos(angle), sin(angle)).normalized()
	
	for i in range(segment_count):
		var segment = segment_scene.instantiate()
		segment.segment_index = i
		segment.worm_controller = self
		segment.position = start_pos + Vector2(-i * SEGMENT_SPACING, 0)
		add_child(segment)
		segments.append(segment)
		positions.append(segment.position)

func _physics_process(delta: float):
	if segments.is_empty():
		return
	
	direction_timer += delta
	if direction_timer >= DIRECTION_CHANGE_TIME:
		direction_timer = 0.0
		change_direction()
	
	# Move head
	var head = segments[0]
	head.position += direction * move_speed * delta
	
	# Keep head on screen (bounce off edges)
	if head.position.x < 20 or head.position.x > 780:
		direction.x *= -1
		head.position.x = clamp(head.position.x, 20, 780)
	if head.position.y < 20 or head.position.y > 350:
		direction.y *= -1
		head.position.y = clamp(head.position.y, 20, 350)
	
	positions[0] = head.position
	
	# Follow segments
	for i in range(1, segments.size()):
		var prev_pos = positions[i - 1]
		var current_pos = segments[i].position
		var dist = current_pos.distance_to(prev_pos)
		
		if dist > SEGMENT_SPACING:
			var move_dir = (prev_pos - current_pos).normalized()
			segments[i].position = prev_pos - move_dir * SEGMENT_SPACING
		
		positions[i] = segments[i].position
		segments[i].queue_redraw()

func change_direction():
	# Random direction change with bias toward moving down
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()
	
	# Bias towards moving down and side to side (not too much up)
	if direction.y < 0:
		direction.y = abs(direction.y) * 0.3
	direction = direction.normalized()

func segment_destroyed(segment):
	var index = segments.find(segment)
	if index != -1:
		segments.remove_at(index)
		positions.remove_at(index)
		segment.queue_free()
		
		# Add score based on level
		var points = 10 + (Global.current_level - 1) * 5
		Global.add_score(points)
		
		# Check if all segments destroyed
		if segments.is_empty():
			# Level complete!
			level_complete()

func level_complete():
	# Wait a moment before transitioning
	await get_tree().create_timer(0.5).timeout
	
	if Global.current_level >= Global.max_level:
		# Game complete!
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")
	else:
		# Next level
		Global.next_level()
		get_tree().change_scene_to_file("res://scenes/LevelTransition.tscn")