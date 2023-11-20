extends Node2D

@onready var time_label : Label = $TimeLeft
@onready var camera_controls = $Camera2D
var time_left : float = 60
var end_scene : PackedScene = preload("res://end_menu.tscn")

func _process(delta):
	time_left -= delta
	time_label.text = str(floor(time_left))
	if time_left < 0:
		var inst_end_scene = end_scene.instantiate()
		inst_end_scene.set_score(camera_controls.score)
		get_parent().add_child(inst_end_scene)
		self.queue_free()
