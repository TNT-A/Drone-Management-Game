extends State
class_name DroneSearch

var hub : DroneHub 
var target : Vector2
var speed : int

var hovering : bool = false

func enter():
	speed = parent_body.speed
	hub = parent_body.hub
	hovering = false

func physics_update(_delta: float):
	if !is_instance_valid(hub):
		hub = parent_body.hub
	check_transitions()
	parent_body.sprite.position = parent_body.sprite.position.lerp(Vector2(0,-30), 0.08)
	search()

func search():
	var dist = parent_body.global_position.distance_to(get_global_mouse_position())
	if dist >= 5:
		parent_body.global_position = parent_body.global_position.lerp(get_global_mouse_position(), 0.1)
		#print("I'm far")
	else:
		parent_body.global_position = get_global_mouse_position()
		#print("I'm searching")

func _on_pickup_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if is_instance_valid(area):
		if area.owner is Carryable:
			var current_carryable : Carryable = area.owner
			if !current_carryable.is_carried and !current_carryable.is_hovered:
				current_carryable.is_hovered = true 
				hovering = true
				parent_body.carryable_target = current_carryable

func _on_pickup_area_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if is_instance_valid(area):
		if area.owner is Carryable:
			var current_carryable : Carryable = area.owner
			current_carryable.is_hovered = false 
			hovering = false
			parent_body.carryable_target = null

func check_transitions():
	if !Input.is_action_pressed("Left_Click"):
		if hovering and parent_body.can_pickup:
			SignalBus.transitioned.emit(self, "PickUp")
		else:
			SignalBus.transitioned.emit(self, "Follow")
			#print("Let go of mouse")
	if parent_body != hub.selected_drone:
		parent_body.can_pickup = false
		SignalBus.transitioned.emit(self, "Follow")
		#print("Not selected drone")
