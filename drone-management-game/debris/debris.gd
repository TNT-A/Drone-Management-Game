extends Node2D
class_name Carryable

@export var weight = 1
@export var value = 1

var is_hovered : bool = false
var is_carried : bool = false

var carrier : Drone

var scrap_type : String = "silver"

var debris_sprites : Dictionary = {
	"rusty" = preload("res://sprites/scrap/rusty_scrap.png"),
	"silver" = preload("res://sprites/scrap/silver_scrap.png"),
	"spirit" = preload("res://sprites/scrap/spirit_scrap.png"),
	"gold" = preload("res://sprites/scrap/gold_scrap.png")
}

var debris_values : Dictionary = {
	"rusty" = 1,
	"silver" = 5,
	"spirit" = 20,
	"gold" = 50
}

var debris_weights : Dictionary = {
	"rusty" = 1,
	"silver" = 3,
	"spirit" = 5,
	"gold" = 7
}

func _ready() -> void:
	$Sprite2D.texture = debris_sprites[scrap_type]
	value = debris_values[scrap_type]
	weight = debris_weights[scrap_type]
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
