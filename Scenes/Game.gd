extends Node2D


func _on_Quit_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")	

func _on_Again_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")