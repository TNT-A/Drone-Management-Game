extends Control

var gane_manager
var hub : DroneHub

func _ready() -> void:
	gane_manager = get_parent().get_parent().get_parent()
	hub = gane_manager.hub

func _physics_process(delta: float) -> void:
	if !is_instance_valid(hub):
		hub = gane_manager.hub
	$CenterContainer/ColorRect/Label.text = str(hub.selected_num + 1) 
