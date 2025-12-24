extends Node2D

@onready var player = $Player
@onready var worm_controller = $WormController
@onready var score_label = $UI/ScoreLabel

func _ready():
	pass

func _process(_delta):
	score_label.text = "SCORE: %d" % Global.score
	
	# Check for ESC to pause/menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")