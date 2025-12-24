extends Control

@onready var level_label = $VBoxContainer/LevelLabel
@onready var stats_label = $VBoxContainer/StatsLabel
@onready var continue_button = $VBoxContainer/ContinueButton

func _ready():
	level_label.text = "LEVEL %d" % Global.current_level
	
	var segments = 10 + (Global.current_level - 1) * 3
	var speed = 50 + (Global.current_level - 1) * 15
	var points = 10 + (Global.current_level - 1) * 5
	
	stats_label.text = "SEGMENTS: %d\nSPEED: %d\nPOINTS: %d per segment" % [segments, speed, points]
	
	continue_button.pressed.connect(_on_continue_pressed)
	
	# Auto continue after 3 seconds
	await get_tree().create_timer(3.0).timeout
	if is_inside_tree():
		_on_continue_pressed()

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")