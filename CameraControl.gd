class_name CameraControl
extends Camera2D

@onready var lens : Node2D = $Lens
@onready var arrow : Sprite2D = $Lens/Lens/Arrow
@onready var audio_shutter : AudioStreamPlayer = $AudioStreamPlayer
@onready var label_score : Label = $"../Score"
@onready var lens_blur : Sprite2D = $Lens/LensBlurFilter
@onready var filtro = $"../Filter"
@onready var effect_player : AnimationPlayer = $Lens/Lens/AnimationPlayer

var arrow_correct = [5.8, 6.7]
var focusing : bool = false
var score : int = 0
var mouse_on : bool = false
var blur_factor : float = 0
var rotation_factor : float = 0
var current_cat : Cat

func _unhandled_input(event):
	if event.is_action_pressed("Click") and mouse_on:
		print("DEBUG: Starting photo")
		focusing = true
		rotation_factor = randf_range(2, 5)
		blur_factor = rotation_factor
	if event.is_action_released("Click") and mouse_on:
		print("DEBUG: Photo done")
		audio_shutter.play()
		focusing = false
		# Get score
		if arrow.rotation > arrow_correct[0] and arrow.rotation < arrow_correct[1]:
			if not current_cat.cat_shown:
				return
			print("DEBUG: Photo done correctly!! with ", arrow.rotation)
			score += floori(100*(arrow.rotation - arrow_correct[0]))
			effect_player.play("correct")
		arrow.rotation = 0
		label_score.text = str(score)


func check_cats():
	for cat in get_tree().get_nodes_in_group("cat"):
		var distance = get_global_mouse_position().distance_to(cat.global_position)
		if distance < 40:
			current_cat = cat
			return true
	current_cat = null
	return false


func _process(delta):
	# Focus camera
	if focusing && mouse_on:
		blur_factor -= clamp(rotation_factor * delta, 0, 100)
		# lens_blur.material.set_shader_parameter("lod", blur_factor)
		filtro.material.set_shader_parameter("desenfoque", blur_factor)
		filtro.material.set_shader_parameter("oscuridad", 0.75)
		arrow.rotate(rotation_factor * PI * delta)
	else:
		blur_factor = 0
		# lens_blur.material.set_shader_parameter("lod", 0)
		filtro.material.set_shader_parameter("desenfoque", 0)
		filtro.material.set_shader_parameter("oscuridad", 1)
		focusing = false
		arrow.rotation = 0
		lens.position = get_local_mouse_position()
		filtro.material.set_shader_parameter("posR", get_viewport().get_mouse_position())
		# Check if its close to a cat
		mouse_on = check_cats()
