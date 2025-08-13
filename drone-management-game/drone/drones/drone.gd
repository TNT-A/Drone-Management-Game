extends Node2D
class_name Drone

@onready var hub : DroneHub = get_parent()
@onready var sprite : Sprite2D = $Sprite2D

@export var weight_capacity : int = 3

var target : Vector2 = Vector2(0, 0)
var speed : int = 200

var at_target : bool = true
var can_pickup : bool = true

var carryable_target : Carryable
var current_carryable : Carryable 

func _physics_process(delta: float) -> void:
	check_target()
	if is_instance_valid(current_carryable):
		can_pickup = false

func check_target():
	var dist = global_position.distance_to(target)
	if dist >= 10.0:
		at_target = false
		#print("Distance between: ", global_position, " & ", target, "is ", dist)
	else:
		at_target = true
		#print("I'm at target, dist is: ", dist)
