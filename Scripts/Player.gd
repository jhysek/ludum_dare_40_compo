extends KinematicBody2D

signal world_changed

var VEC_LEFT = Vector2(-1, 0)
var VEC_RIGHT = Vector2(1, 0)
var VEC_UP = Vector2(0, -1)
var VEC_DOWN = Vector2(0, 1)
var SPEED = 200

var velocity = Vector2(0,0)
var is_moving = false
var walk_noise = 100

var collected  = 0

func _ready():
	set_fixed_process(true)

func setOrientation(velocity):
	if velocity.x < 0:
		get_node("Sprite").set_flip_h(true)
	else:
		get_node("Sprite").set_flip_h(false)

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
		
		
func _fixed_process(delta):
	var new_velocity = Vector2(0,0)

	if Input.is_action_pressed("ui_left"):
		new_velocity += VEC_LEFT
		setOrientation(new_velocity)
		
	if Input.is_action_pressed("ui_right"):
		new_velocity += VEC_RIGHT
		setOrientation(new_velocity)
		
	if Input.is_action_pressed("ui_up"):
		new_velocity += VEC_UP
		
	if Input.is_action_pressed("ui_down"):
		new_velocity += VEC_DOWN
		
	if Input.is_action_pressed("ui_accept"):
		get_node("SoundArea").makeNoise(100)
		
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
		area.goal = get_pos()
		area.nav  = get_node("/root/World/Navigation")
		area.chasing = true
		
func itemCollected():
	collected += 1
	get_node("/root/World/CanvasLayer/UI/CollectedLabel").set_text(str(collected) + " / " + str(10))
