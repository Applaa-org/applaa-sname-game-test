extends Node2D

@onready var player = $Player
@onready var worm_controller = $WormController
@onready var score_label = $UI/ScoreLabel
@onready var level_label = $UI/LevelLabel

func _ready():
	update_ui()

func _process(_delta):
	update_ui()
	
	# Check for ESC to pause/menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func update_ui():
	score_label.text = "SCORE: %d" % Global.score
	level_label.text = "LEVEL: %d/%d" % [Global.current_level, Global.max_level]