extends State
class_name DroneIdle

var hub : DroneHub 

func enter():
	hub = parent_body.hub
	if parent_body.sprite:
		parent_body.sprite.play(parent_body.drone_type_string + "_idle")
		#print("setting animation")

func physics_update(_delta: float):
	if !is_instance_valid(hub):
		hub = parent_body.hub
	if parent_body.can_pickup:
		parent_body.sprite.position = parent_body.sprite.position.lerp(Vector2(0,0), .08)
	check_transitions()
	parent_body.velocity = parent_body.velocity.lerp(Vector2(0,0), 0.5)

func check_transitions():
	if !parent_body.at_target:
		SignalBus.transitioned.emit(self, "Follow")
	if parent_body.dropping_off:
		SignalBus.transitioned.emit(self, "Dropoff")
	if Input.is_action_pressed("Left_Click") and parent_body == hub.selected_drone:
		#print("Trying to transition")
		SignalBus.transitioned.emit(self, "Search")
