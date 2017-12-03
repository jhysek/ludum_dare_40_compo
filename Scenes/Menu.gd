extends Node2D

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")
	
func _on_Button1_pressed():
	get_tree().quit()