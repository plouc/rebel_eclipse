extends Control

func _ready():
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://game.tscn")
