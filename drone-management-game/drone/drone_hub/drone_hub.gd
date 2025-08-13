extends Node2D
class_name DroneHub

var player : Player
var game_manager

var selected_drone : Drone
var selected_num

var drones : Array[Node2D] = [
	
]

var drone_slots : Array = [
	Vector2(1,0), 
	Vector2(2,0), 
	Vector2(3,0), 
	Vector2(4,0), 
	Vector2(5,0), 
]

var slot_adjustments : Array = [
	Vector2(-40, -45), 
	Vector2(40, -45), 
	Vector2(55, 15), 
	Vector2(-55, 15), 
	Vector2(0,45), 
]

@onready var markers : Array = [
	$ColorRect,
	$ColorRect2,
	$ColorRect3,
	$ColorRect4,
	$ColorRect5
]

func _ready() -> void:
	game_manager = get_parent().get_parent()
	drones.clear()
	for child in get_children():
		if child is Drone:
			drones.append(child)
	if len(drones) >= 1:
		selected_drone = drones[0]
		selected_num = 0
		#print("Selected a drone: ", selected_drone)
		#print(drones)
	await get_parent().get_parent().ready
	SignalBus.register_drone_hub.emit(self)


func _physics_process(delta: float) -> void:
	if !is_instance_valid(player):
		player = game_manager.player
	set_drone_slots()
	#print(drone_slots)
	set_targets()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Scroll_Up"):
		selected_num += 1
		if selected_num > 4:
			selected_num = 0
	if event.is_action_pressed("Scroll_Down"):
		selected_num -= 1
		if selected_num < 0:
			selected_num = 4
	selected_drone = drones[selected_num]

func set_drone_slots():
	if player:
		for slot in drone_slots:
			var num = drone_slots.find(slot)
			#print(markers[num])
			slot = player.global_position + slot_adjustments[num]
			drone_slots[num] = slot
			markers[num].global_position = slot

func set_targets():
	if player:
		for drone in drones:
			var num = drones.find(drone)
			drone.target = drone_slots[num]
