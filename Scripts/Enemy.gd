extends Area2D

var SPEED = 160
var nav  = null setget set_nav
var goal = Vector2()
var path = []
var chasing = false
var orientation = Vector2(0,0)

onready var exclamation = get_node("Exclamation")
onready var ray         = get_node("Ray")
onready var player      = get_node("/root/World/Player")
onready var world       = get_node("/root/World")

func set_nav(new_nav):
	nav = new_nav
	update_path()
	
func update_path():
	path = nav.get_simple_path(get_pos(), goal, false)
	if path.size() == 0:
		print("NEVIM KUDY :(")

func _ready():
	set_fixed_process(true)

func set_orientation(diff_vec):
	if diff_vec.x < 0 and orientation.x != -1:
		orientation.x = -1
		get_node("Sprite").set_flip_h(true)
		get_node("Ray").set_cast_to(Vector2(-1500, 0))
		
	if diff_vec.x > 0 and orientation.x != 1:
		orientation.x = 1
		get_node("Sprite").set_flip_h(false)
		get_node("Ray").set_cast_to(Vector2(1500, 0))

func _fixed_process(delta):
	var player_distance = get_pos().distance_to(player.get_pos())
	
	if world.paused:
		return 
		 			
	if chasing:
		exclamation.show()
		if path.size() > 1:
			var d = get_pos().distance_to(path[0])
			if d > 2:
				var new_pos = get_pos().linear_interpolate(path[0], SPEED * delta / d)
				set_orientation(new_pos - get_pos())
				set_pos(new_pos)
			else:
				path.remove(0)
		else:
			chasing = false
			exclamation.hide()
			
		if player_distance < 60:
			chasing = false
			player.busted()		
	else:
		if player_distance > 60 and ray.is_colliding():
			var target = ray.get_collider()
			if target and target.is_in_group("Player"):
				chasePlayer()
		
func chasePlayer():
	if not player.is_busted:
		get_node("/root/World/SamplePlayer").play("seen")
		var player_pos = player.get_pos()
		goal = player.get_pos()
		nav  = get_node("/root/World/Navigation")
		update_path()
		chasing = true
