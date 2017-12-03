extends Node2D

var paused = false
var controls = !GameState.control_displayed
var total_collectables = 0
var level_cleared = false

func _ready():
	level_cleared = false
	if !GameState.control_displayed:
		GameState.control_displayed = true
		get_node("CanvasLayer/UI/ControlInfo/AnimationPlayer").play("Show")
		paused = true
	total_collectables = get_node("Collectables").get_child_count()
	get_node("CanvasLayer/UI/CollectedLabel").set_text("0 / " + str(total_collectables))
	set_process_input(true)
	
func _input(event):
	if controls and event.type == InputEvent.KEY and Input.is_action_pressed("ui_accept"):
		controls = false
		paused   = false

		get_node("CanvasLayer/UI/ControlInfo/AnimationPlayer").play_backwards("Show")
		return
		
	if level_cleared and event.type == InputEvent.KEY and Input.is_action_pressed("ui_accept"):
		open_next_level()
		return
		
	if Input.is_action_pressed("ui_cancel"):
		if paused:
			resume_game()
		else:
			pause_game()

func goto_next_level():
	paused = true
	var next_level = GameState.get_next_level_name()
	if next_level:
		level_cleared = true
		get_node("/root/World/CanvasLayer/UI/LevelCleared/AnimationPlayer").play("Show")
	else:
		get_node("CanvasLayer/UI/Finished").show()
		get_node("CanvasLayer/UI/Finished/AnimationPlayer").play("Show")

func open_next_level():
	var next_level = GameState.get_next_level_name()
	if next_level:
		GameState.set_current_level(next_level)
		get_tree().change_scene("res://Scenes/" + next_level + ".tscn")

func pause_game():
	paused = true
	get_node("CanvasLayer/UI/Paused/AnimationPlayer").play("Show")

func resume_game():
	paused = false
	get_node("CanvasLayer/UI/Paused/AnimationPlayer").play_backwards("Show")

func _on_Resume_pressed():
	resume_game()
	
func _on_Quit_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")	

func _on_Again_pressed():
	get_tree().change_scene("res://Scenes/" + GameState.get_current_level_name() + ".tscn")