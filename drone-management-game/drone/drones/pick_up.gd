extends State
class_name DronePickUp

var hub : DroneHub 

var picking_up : bool = true
var can_pickup_carryable : bool = true

var weight_capacity : int = 3

func enter():
	hub = parent_body.hub
	parent_body.velocity = Vector2(0,0)
	weight_capacity = parent_body.weight_capacity
	picking_up = true
	can_pickup_carryable = true

func physics_update(_delta: float):
	if is_instance_valid(parent_body.carryable_target):
		parent_body.global_position = parent_body.global_position.lerp(parent_body.carryable_target.global_position, .4)
	check_transitions()
	if !is_instance_valid(hub):
		hub = parent_body.hub
	pick_up()

func pick_up():
	if is_instance_valid(parent_body.carryable_target):
		if !parent_body.carryable_target.is_carried:
			parent_body.sprite.position = parent_body.sprite.position.lerp(Vector2(0,0), .15)
			if is_equal_approx(parent_body.sprite.position.y, 0):
				parent_body.carryable_target.is_hovered = false
				print("WAHOO PICKUP YEAAAA BABY WOOOO")
				if weight_capacity >= parent_body.carryable_target.weight and parent_body.can_pickup:
					parent_body.sprite.position = parent_body.sprite.position.lerp(Vector2(0,-15), 0.08)
					parent_body.carryable_target.carrier = parent_body
					parent_body.carryable_target.is_carried = true
					parent_body.current_carryable = parent_body.carryable_target
					parent_body.carryable_target = null
					parent_body.can_pickup = false
					picking_up = false
				else:
					can_pickup_carryable = false
	else:
		can_pickup_carryable = false


func check_transitions():
	if !picking_up:
		SignalBus.transitioned.emit(self, "Follow")
		print("Not picking up")
	if !can_pickup_carryable:
		SignalBus.transitioned.emit(self, "Follow")
	if !is_instance_valid(parent_body.carryable_target):
		SignalBus.transitioned.emit(self, "Follow")
