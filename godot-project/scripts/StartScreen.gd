extends Control

func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)
	
	# Display high score
	if Global.high_score > 0:
		$VBoxContainer/HighScoreLabel.text = "HIGH SCORE: %d" % Global.high_score
	else:
		$VBoxContainer/HighScoreLabel.text = "HIGH SCORE: 0"

func _on_start_pressed():
	Global.reset_score()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	get_tree().quit()