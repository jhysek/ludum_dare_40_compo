extends PathFollow2D

var SPEED = 100
var at_path = true

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if at_path:
		set_offset(get_offset() + delta * SPEED)