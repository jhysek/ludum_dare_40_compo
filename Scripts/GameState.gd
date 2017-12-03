extends Node

export var control_displayed = false

var levels        = ["Game"]
var current_level = 0

func _ready():
	print("State loaded")	
	pass
	
func set_current_level(name):
	var idx = levels.find(name)
	if idx >= 0:
		current_level = idx
	
func get_next_level_name():
	if levels.has(current_level + 1):
		levels[current_level + 1]
	else:
		null 