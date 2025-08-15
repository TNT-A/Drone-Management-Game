extends Node2D

@export var host : CharacterBody2D
@export var speed : int = 200

var acceleration : float = 0.2
var accept_input : bool = true

func _physics_process(delta: float) -> void:
	speed = get_parent().speed
	move()

func get_direction():
	var input : Vector2 = Vector2()
	if Input.is_action_pressed("Move_Up"):
		input.y -=1
	if Input.is_action_pressed("Move_Down"):
		input.y +=1
	if Input.is_action_pressed("Move_Left"):
		input.x -=1
	if Input.is_action_pressed("Move_Right"):
		input.x +=1
	return input

func move():
	var dir = get_direction()
	host.velocity = host.velocity.lerp(dir * speed, acceleration)
	if accept_input:
		host.move_and_slide()
