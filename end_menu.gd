extends Node2D

var score : int = 0
@onready var label : Label = $CanvasLayer/Score

func set_score(new_score):
	score = new_score


func _ready():
	label.text = str(score)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://level.tscn")
	self.queue_free()
