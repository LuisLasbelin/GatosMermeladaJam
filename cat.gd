class_name Cat
extends Node2D

var cat_shown : bool = false
@export var flip : bool = false
@onready var sprite : Sprite2D = $Sprite2D
@onready var timer : Timer = $Timer
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var sound : AudioStreamPlayer = $Plop


func _ready():
	sprite.flip_h = flip
	sprite.set_texture(null)
	timer.start(randf_range(2, 5))


func _on_timer_timeout():
	if cat_shown:
		cat_shown = false
		animator.play("cat_hide")
		timer.start(randf_range(2, 5))
	else:
		cat_shown = true
		animator.play("cat_show")
		sound.play()
		timer.start(randf_range(1, 2))
