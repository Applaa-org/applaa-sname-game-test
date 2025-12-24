extends Control

func _ready():
	$VBoxContainer/ScoreLabel.text = "FINAL SCORE: %d" % Global.score
	$VBoxContainer/HighScoreLabel.text = "HIGH SCORE: %d" % Global.high_score
	
	Global.save_high_score()
	
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	$VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	$VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)

func _on_restart_pressed():
	Global.reset_score()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed():
	get_tree().quit()