extends Node2D

var paused = false
var controls = !GameState.control_displayed
var total_collectables = 0

func _ready():
	if !GameState.control_displayed:
		GameState.control_displayed = true
		get_node("CanvasLayer/UI/ControlInfo/AnimationPlayer").play("Show")
		paused = true
	total_collectables = get_node("Collectables").get_child_count()
	get_node("CanvasLayer/UI/CollectedLabel").set_text("0 / " + str(total_collectables))
	set_process_input(true)
	
func _input(event):
	if controls and event.type == InputEvent.KEY:
		controls = false
		paused   = false

		get_node("CanvasLayer/UI/ControlInfo/AnimationPlayer").play_backwards("Show")
		return
		
	if Input.is_action_pressed("ui_cancel"):
		if paused:
			resume_game()
		else:
			pause_game()

func goto_next_level():
	var next_level = GameState.get_next_level_name()
	if next_level:
		GameState.set_current_level(next_level)
		get_tree().change_scene("res://Scenes/" + next_level + ".tscn")
	else:
		paused = true
		get_node("CanvasLayer/UI/Finished/AnimationPlayer").play("Show")


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