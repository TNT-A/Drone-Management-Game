extends Node2D

var debris_scene : PackedScene = preload("res://debris/debris.tscn")

@export var debris_count : int = 5
@export var debris_type : String = "rusty"

var spawned_debris : bool = false
var current_debris : Carryable

var debris_sprites : Dictionary = {
	"rusty" = preload("res://sprites/scrap_pile/rusty_scrap_pile.png"),
	"silver" = preload("res://sprites/scrap_pile/silver_scrap_pile.png"),
	"spirit" = preload("res://sprites/scrap_pile/spirit_scrap_pile.png"),
	"gold" = preload("res://sprites/scrap_pile/gold_scrap_pile.png")
}

func _ready() -> void:
	if !is_instance_valid(debris_scene):
		debris_scene = load("res://debris/debris.tscn")
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
	new_debris.scrap_type = debris_type
	get_parent().add_child(new_debris)
	current_debris = new_debris
	new_debris.global_position = global_position
	#print("I spawned a debris: ", new_debris.global_position, " ", global_position)

func destroy():
	queue_free()
