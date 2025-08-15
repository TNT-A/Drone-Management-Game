extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("scroll up")

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
