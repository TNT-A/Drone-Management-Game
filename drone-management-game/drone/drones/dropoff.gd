extends State
class_name DroneDropoff

var hub : DroneHub 
var dropoff_spot : Vector2 = Vector2(0,0)
var current_carryable : Carryable

var dropping_off : bool = true
var found_drop_point : bool = false

func enter():
	hub = parent_body.hub
	dropoff_spot = parent_body.dropoff_spot
	current_carryable = parent_body.current_carryable
	dropping_off = true
	found_drop_point = false

func physics_update(_delta: float):
	if !is_instance_valid(hub):
		hub = parent_body.hub
	check_transitions()
	parent_body.velocity = parent_body.velocity.lerp(Vector2(0,0), 0.5)
	dropoff()

func dropoff():
	#print("Tryna drop off: ", current_carryable)
	if is_instance_valid(current_carryable):
		parent_body.global_position = parent_body.global_position.lerp(dropoff_spot, .05)
		if found_drop_point:
			submit_resource()
	else:
		dropping_off = false

func _on_pickup_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("drop_point"):
		await get_tree().create_timer(.5).timeout
		found_drop_point = true

func submit_resource():
	#print("resource just submitted WOOOOOOO YEA")
	SignalBus.submit_resource.emit(current_carryable)
	parent_body.can_pickup = true
	parent_body.dropping_off  = false
	parent_body.carryable_target = null
	parent_body.current_carryable = null
	dropping_off = false

func check_transitions():
	if dropping_off == false:
		SignalBus.transitioned.emit(self, "Follow")
