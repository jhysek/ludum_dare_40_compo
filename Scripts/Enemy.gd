extends Area2D

var SPEED = 100
var nav  = null setget set_nav
var goal = Vector2()
var path = []
var chasing = false
var in_area = null

onready var exclamation = get_node("Exclamation")
onready var ray         = get_node("Ray")
onready var player      = get_node("/root/World/Player")

func set_nav(new_nav):
	nav = new_nav
	update_path()
	
func update_path():
	path = nav.get_simple_path(get_pos(), goal, false)
	if path.size() == 0:
		print("NEVIM KUDY :(")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if chasing:
		exclamation.show()
		if path.size() > 1:
			var d = get_pos().distance_to(path[0])
			if d > 2:
				set_pos(get_pos().linear_interpolate(path[0], SPEED * delta / d))
			else:
				path.remove(0)
		else:
			chasing = false
			exclamation.hide()
			print("GOTCHA")
			if in_area:
				print("STILL IN AREA")
	else:
		ray.set_cast_to(player.get_pos())
		if ray.is_colliding():
			var target = ray.get_collider()
			print(target)
		
func _on_Enemy_area_enter( area ):
	in_area = area
	print("IN AREA")
	print(area)

func _on_Enemy_area_exit( area ):
	in_area = null