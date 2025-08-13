extends State
class_name DroneFollow

var hub : DroneHub 
var target : Vector2
var speed : int

func enter():
	speed = parent_body.speed
	hub = parent_body.hub

func physics_update(_delta: float):
	if !is_instance_valid(hub):
		hub = parent_body.hub
	check_transitions()
	parent_body.sprite.position = parent_body.sprite.position.lerp(Vector2(0,-15), 0.08)
	follow()
	adjust_speed()

func follow():
	target = parent_body.target
	var dir = parent_body.global_position.direction_to(target)
	parent_body.velocity = parent_body.velocity.lerp(dir * speed, 1)
	parent_body.move_and_slide()
	#print(target, " ", global_position, " ", parent_body.velocity)

var max_speed = 300
var min_speed = 50
var base_speed = 200
var target_dist = 65
func adjust_speed():
	var dist = parent_body.global_position.distance_to(target)
	speed = base_speed*(dist-target_dist)
	if speed >= max_speed:
		speed = max_speed
	if speed <= min_speed:
		speed = min_speed

func check_transitions():
	if parent_body.at_target:
		SignalBus.transitioned.emit(self, "Idle")
	if parent_body.dropping_off:
		SignalBus.transitioned.emit(self, "Dropoff")
	if Input.is_action_pressed("Left_Click") and parent_body == hub.selected_drone:
		#print("Trying to transition")
		SignalBus.transitioned.emit(self, "Search")
