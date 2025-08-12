extends Node2D

var main_menu : PackedScene = preload("res://main_menu/main_menu.tscn")

#Bool funcs for various active states
var is_paused : bool = false

func _ready() -> void:
	SignalBus.pause_changed.connect(set_paused)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		set_paused()

func set_paused():
	if is_paused:
		is_paused = false
	else:
		is_paused = true
	if is_paused:
		$PauseUI.visible = true
		Engine.time_scale = 0.0
	else:
		$PauseUI.visible = false
		Engine.time_scale = 1.0
