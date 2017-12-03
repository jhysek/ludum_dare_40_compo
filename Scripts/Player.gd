extends KinematicBody2D

signal world_changed

var VEC_LEFT = Vector2(-1, 0)
var VEC_RIGHT = Vector2(1, 0)
var VEC_UP = Vector2(0, -1)
var VEC_DOWN = Vector2(0, 1)
var SPEED = 200

var velocity = Vector2(0,0)
var is_moving = false
var walk_noise = 80
var is_busted  = false
var collected  = 0
var noise_level = 0

onready var world = get_node("/root/World")

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	
func _input(event):
	if !world.paused:
		if Input.is_action_pressed("ui_accept") and event.pressed:
			get_node("SoundArea").makeNoise(300)
			get_node("/root/World/SamplePlayer").play("attention" + str(randi() % 2 + 1))

func setAnimation(velocity, new_velocity):
	var current_animation = get_node("Sprite/AnimationPlayer").get_current_animation()
	var new_animation     = "Idle"
	
	if new_velocity.y > 0:
		new_animation = "WalkDown"
		
	if new_velocity.y < -0:
		new_animation = "WalkUp"
		
	if new_velocity.x > 0:
		new_animation = "WalkRight"
	
	if new_velocity.x < 0:
		new_animation = "WalkLeft"
		
	if current_animation != new_animation:
		get_node("Sprite/AnimationPlayer").play(new_animation)

		
func busted():
	get_node("Sprite/AnimationPlayer").play("Busted")
	get_node("SoundArea").makeNoise(500)
	var sample_player = get_node("/root/World/SamplePlayer")
	sample_player.stop_all()
	sample_player.play("busted")
	get_node("/root/World/CanvasLayer/UI/Busted/AnimationPlayer").play("Show")
	is_busted = true
	is_moving = false
	
func _fixed_process(delta):
	var new_velocity = Vector2(0,0)
		
	if !world.paused and !is_busted:
		if Input.is_action_pressed("ui_left"):
			new_velocity += VEC_LEFT
		
		if Input.is_action_pressed("ui_right"):
			new_velocity += VEC_RIGHT
		
		if Input.is_action_pressed("ui_up"):
			new_velocity += VEC_UP
		
		if Input.is_action_pressed("ui_down"):
			new_velocity += VEC_DOWN
		
		is_moving = new_velocity != Vector2(0, 0)
	
		setAnimation(velocity, new_velocity)
		
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
		get_node("/root/World/SamplePlayer").play("heard")
		area.goal = get_pos()
		area.set_nav(get_node("/root/World/Navigation"))
		area.chasing = true
		
		
func itemCollected():
	collected += 1
	noise_level += 1
	walk_noise = 50 + noise_level * 30
	get_node("/root/World/CanvasLayer/UI/NoiseLabel").set_text(str(noise_level))
	get_node("/root/World/CanvasLayer/UI/CollectedLabel").set_text(str(collected) + " / " + str(10))
	get_node("SoundArea").makeNoise(200)
	get_node("/root/World/SamplePlayer").play("chacha" + str(randi() % 3 + 1))
	