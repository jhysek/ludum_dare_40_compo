extends Area2D

var is_active = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func activate():
	is_active = true
	add_to_group("Exit")
	get_node("AnimationPlayer").play("Enable")

func _on_Exit_body_enter( body ):
	if is_active and body.is_in_group("Player"):
		get_node("/root/World").goto_next_level()