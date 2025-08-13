extends Node2D

var debris_scene : PackedScene = preload("res://debris/debris.tscn")

@export var debris_count : int = 5
@export var debris_type : String = "Reg"

var spawned_debris : bool = false
var current_debris : Carryable

var debris_list : Dictionary = {
	"Reg" = "res://debris/debris.tscn"
}

var debris_sprites : Dictionary = {
	"Reg" = preload("res://sprites/placeholders/Pot.png")
}

func _ready() -> void:
	var current_debris_scene = debris_list[debris_type]
	#print(current_debris_scene)
	debris_scene = load(current_debris_scene)
	$Sprite2D.texture = debris_sprites[debris_type]

func _physics_process(delta: float) -> void:
	if is_instance_valid(current_debris):
		if current_debris.is_carried:
			spawned_debris = false
			current_debris = null
	if debris_count <= 0:
		destroy()
	if !spawned_debris:
		spawn_debris()


func spawn_debris():
	spawned_debris = true
	debris_count -= 1
	var new_debris : Carryable = debris_scene.instantiate()
	new_debris.z_index = -1
	new_debris.scale = Vector2(1,1)
	get_parent().add_child(new_debris)
	current_debris = new_debris
	new_debris.global_position = global_position
	print("I spawned a debris: ", new_debris.global_position, " ", global_position)

func destroy():
	queue_free()
