extends Node2D

@onready var player : Player 
@onready var hub : DroneHub

var main_menu : PackedScene = preload("res://main_menu/main_menu.tscn")

#Bool funcs for various active states
var is_paused : bool = false

func _ready() -> void:
	SignalBus.pause_changed.connect(set_paused)
	SignalBus.register_player.connect(register_player)
	SignalBus.register_drone_hub.connect(register_drone_hub)

func register_player(pot_player):
	player = pot_player
	#print("I got the player")

func register_drone_hub(pot_drone_hub):
	hub = pot_drone_hub
	#print("I got the player")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		set_paused()

func set_paused():
	if is_paused:
		is_paused = false
	else:
		is_paused = true
	if is_paused:
		$CanvasLayer/PauseUI.visible = true
		Engine.time_scale = 0.0
	else:
		$CanvasLayer/PauseUI.visible = false
		Engine.time_scale = 1.0
