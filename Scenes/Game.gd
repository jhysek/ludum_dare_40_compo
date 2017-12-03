extends Node2D

var paused = false
var controls = !GameState.control_displayed

func _ready():
	if controls:
		get_node("CanvasLayer/UI/ControlInfo/AnimationPlayer").play("Show")
		paused = true
	set_process_input(true)
	
func _input(event):
	if controls and event.type == InputEvent.KEY:
		controls = false
		paused   = false
		GameState.control_displayed = true
		get_node("CanvasLayer/UI/ControlInfo/AnimationPlayer").play_backwards("Show")
		return
		
	if Input.is_action_pressed("ui_cancel"):
		if paused:
			resume_game()
		else:
			pause_game()

func pause_game():
	paused = true
	get_node("CanvasLayer/UI/Paused/AnimationPlayer").play("Show")

func resume_game():
	paused = false
	get_node("CanvasLayer/UI/Paused/AnimationPlayer").play_backwards("Show")

func _on_Quit_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")	

func _on_Again_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")