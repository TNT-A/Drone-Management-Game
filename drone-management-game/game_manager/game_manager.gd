extends Node2D

@onready var player : Player 
@onready var hub : DroneHub

var main_menu : PackedScene = preload("res://main_menu/main_menu.tscn")

#Bool funcs for various active states
var is_paused : bool = false
var has_notified : bool = false
@export var scrap : int = 0

func _ready() -> void:
	SignalBus.pause_changed.connect(set_paused)
	SignalBus.register_player.connect(register_player)
	SignalBus.register_drone_hub.connect(register_drone_hub)
	SignalBus.submit_resource.connect(process_resource)
	SignalBus.value_upgraded.connect(value_up)
	SignalBus.win_game.connect(game_win)
	SignalBus.minor_notif.emit("I should bring scrap here.", 10.0)

func game_win():
	get_tree().change_scene_to_file("res://UI/end_screen/end.tscn")

var value_boost : int = 0
func value_up():
	value_boost += 1

func process_resource(resource):
	scrap += resource.value + value_boost
	print(scrap)

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
	$CanvasLayer/ShopUI.visible = false
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
