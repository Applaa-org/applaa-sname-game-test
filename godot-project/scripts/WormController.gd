extends Node2D

const SEGMENT_COUNT: int = 12
const SEGMENT_SPACING: float = 20.0
const MOVE_SPEED: float = 60.0
const DIRECTION_CHANGE_TIME: float = 2.0

@onready var segment_scene = preload("res://scenes/WormSegment.tscn")

var segments: Array = []
var positions: Array = []
var direction: Vector2 = Vector2(1, 0)
var direction_timer: float = 0.0

func _ready():
	spawn_worm()

func spawn_worm():
	segments.clear()
	positions.clear()
	
	# Start at top of screen
	var start_pos = Vector2(100, 100)
	
	for i in range(SEGMENT_COUNT):
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
	head.position += direction * MOVE_SPEED * delta
	
	# Keep head on screen (bounce off edges)
	if head.position.x < 20 or head.position.x > 780:
		direction.x *= -1
		head.position.x = clamp(head.position.x, 20, 780)
	if head.position.y < 20 or head.position.y > 300:
		direction.y *= -1
		head.position.y = clamp(head.position.y, 20, 300)
	
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
	# Random direction change
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()
	
	# Bias towards moving down and side to side
	direction.y = abs(direction.y) * 0.5
	direction = direction.normalized()

func segment_destroyed(segment):
	var index = segments.find(segment)
	if index != -1:
		segments.remove_at(index)
		positions.remove_at(index)
		segment.queue_free()
		
		# Add score
		Global.add_score(10)
		
		# Check if all segments destroyed
		if segments.is_empty():
			# Victory!
			get_tree().call_deferred("change_scene_to_file", "res://scenes/VictoryScreen.tscn")