extends KinematicBody2D

signal world_changed

var VEC_LEFT = Vector2(-1, 0)
var VEC_RIGHT = Vector2(1, 0)
var VEC_UP = Vector2(0, -1)
var VEC_DOWN = Vector2(0, 1)
var SPEED = 200

var velocity = Vector2(0,0)
var noise_radius = 0
var zero_noise_radius = 50
var target_noise_radius = 0
var making_noise = false
var walk_noise = 200
var noise_cooldown = 0

onready var shape = get_node("SoundArea/Shape").get_shape()

func _ready():
	set_fixed_process(true)

func makeNoise(radius):
	noise_radius = shape.get_radius()
	target_noise_radius = radius
	making_noise = true
	
func _fixed_process(delta):
	var new_velocity = Vector2(0,0)

	if making_noise:	
		if noise_radius < target_noise_radius:
			noise_radius = lerp(noise_radius, target_noise_radius, 50 * delta)
			shape.set_radius(noise_radius)
		else:
			shape.set_radius(zero_noise_radius)
			making_noise = false
	
	if Input.is_action_pressed("ui_left"):
		new_velocity += VEC_LEFT
		
	if Input.is_action_pressed("ui_right"):
		new_velocity += VEC_RIGHT
		
	if Input.is_action_pressed("ui_up"):
		new_velocity += VEC_UP
		
	if Input.is_action_pressed("ui_down"):
		new_velocity += VEC_DOWN
		
	if Input.is_action_pressed("ui_accept"):
		makeNoise(300)

	noise_cooldown -= 5*delta
	if new_velocity != Vector2(0,0):
		print(noise_cooldown)
		if noise_cooldown <= 0:
			noise_cooldown = 3
			makeNoise(walk_noise)
		
	velocity.x = lerp(velocity.x, new_velocity.x * SPEED * delta, 0.2)
	velocity.y = lerp(velocity.y, new_velocity.y * SPEED * delta, 0.2)
	move(velocity)
	
	if (is_colliding()):
		var n = get_collision_normal()
		new_velocity = n.slide(new_velocity)
		velocity = n.slide(velocity)
		move(new_velocity)

func _on_SoundArea_area_enter( area ):
	if area.is_in_group("Enemy"):
		area.goal = get_pos()
		area.nav  = get_node("/root/World/Navigation")
		area.chasing = true
	
