extends Control

var game_scene : PackedScene = preload("res://game_manager/game_manager.tscn")

func _on_button_pressed() -> void:
	$CenterContainer/VBoxContainer/Label.text = "Generating World.....!"
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)
	else:
		print("No game!")
		game_scene = load("res://game_manager/game_manager.tscn")
		get_tree().change_scene_to_packed(game_scene)
