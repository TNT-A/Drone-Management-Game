extends Node2D
class_name Carryable

@export var weight = 1
@export var value = 1

var is_hovered : bool = false
var is_carried : bool = false

var carrier : Drone

func _ready() -> void:
	SignalBus.submit_resource.connect(use)

func use(resource):
	if self == resource:
		queue_free()

func _physics_process(delta: float) -> void:
	if is_hovered:
		$Sprite2D.scale = Vector2(1.2, 1.2)
	else:
		$Sprite2D.scale = Vector2(1, 1)
	if is_carried:
		if is_instance_valid(carrier):
			global_position = carrier.global_position

#func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#if body is Drone and body.can_pickup:
		#is_hovered = true
		#print("Straight up entering it")
#
#func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#if body is Drone and body.can_pickup:
		#is_hovered = false
		#print("Straight up exiting it")
