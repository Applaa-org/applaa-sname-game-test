extends Node

var score: int = 0
var high_score: int = 0
var current_level: int = 1
var max_level: int = 5

func add_score(points: int):
	score += points
	if score > high_score:
		high_score = score

func reset_score():
	score = 0
	current_level = 1

func next_level():
	current_level += 1

func _ready():
	load_high_score()

func load_high_score():
	if FileAccess.file_exists("user://highscore.save"):
		var file = FileAccess.open("user://highscore.save", FileAccess.READ)
		high_score = file.get_32()
		file.close()

func save_high_score():
	var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	file.store_32(high_score)
	file.close()