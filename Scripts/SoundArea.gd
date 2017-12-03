extends Area2D

var shape
onready var indicator = get_node("Sprite")
onready var player    = get_parent()
onready var sample_player = get_node("/root/World/SamplePlayer")
onready var world     = get_node("/root/World")

var noise_radius          = 0
var noise_indicator_ratio = 0
var zero_noise_radius     = 50
var zero_inicator_scale   = 0.16
var target_noise_radius   = 0
var making_noise          = false
var noise_cooldown        = 0
var step_cooldown         = 1
var target_indicator_opacity = 0.3
var indicator_size = 0



func _ready():
	set_fixed_process(true)
	shape = get_shape(0)
	indicator_size = get_node("Sprite").get_texture().get_size()
	print(indicator_size)
			
func makeNoise(radius):
	noise_radius = shape.get_radius()
	indicator.set_scale(Vector2(zero_inicator_scale, zero_inicator_scale))
	noise_indicator_ratio = noise_radius / indicator.get_scale().x;
	target_noise_radius = radius
	making_noise = true

func _fixed_process(delta):
	if world.paused:
		return
		
	if making_noise:	
		var indicator_opacity = lerp(indicator.get_opacity(), target_indicator_opacity, 0.05)
		indicator.set_opacity(indicator_opacity)
		if noise_radius < target_noise_radius:
			noise_radius = lerp(noise_radius, target_noise_radius, 50 * delta)
			var target_scale = 1 / (indicator_size.x / (noise_radius * 2))
			var indicator_scale = indicator.get_scale().x 
			var scale = lerp(indicator_scale, target_scale, 0.2)
			indicator.set_scale(Vector2(scale, scale))
			shape.set_radius(noise_radius)
		else:
			noise_radius = zero_noise_radius
			shape.set_radius(zero_noise_radius)

			making_noise = false
	else:
		var indicator_scale = indicator.get_scale().x
		if indicator_scale > 0.04: 
			var new_scale = lerp(indicator_scale, 0.04, 0.1)
		#	indicator.set_scale(Vector2(new_scale, new_scale))
		var indicator_opacity = lerp(indicator.get_opacity(), 0, 0.1)
		indicator.set_opacity(indicator_opacity)
	
	noise_cooldown -= 5*delta
	if player.is_moving and noise_cooldown <= 0:
		noise_cooldown = 3
		makeNoise(player.walk_noise)
		
	step_cooldown -= 5*delta
	if player.is_moving and step_cooldown <= 0:
		sample_player.play("step")
		#sample_player.set_pitch_scale(3,rand_range(0.8, 1.2))
		step_cooldown = 1.55