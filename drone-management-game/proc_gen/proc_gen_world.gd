extends Node2D

@export var noise_height_text : NoiseTexture2D
@export var noise_tree_text : NoiseTexture2D

var noise : Noise
var tree_noise : Noise

var width : int = 300 
var height : int = 300 

@onready var water: TileMapLayer = $TilemapHo/water
@onready var snow_water: TileMapLayer = $TilemapHo/snow_water
@onready var snow_patch: TileMapLayer = $TilemapHo/snow_patch
@onready var cliffs: TileMapLayer = $TilemapHo/cliffs
@onready var patch_decor: TileMapLayer = $TilemapHo/patch_decor
@onready var environment: TileMapLayer = $TilemapHo/environment

var source_id = 6
var water_atlas = Vector2i(1, 15)
var land_atlas = Vector2i(2, 19)

var snow_tile_array : Array = []
var terrain_snow_int = 0

var snow_patch_tile_array : Array = []
var terrain_snow_patch_int = 0

var cliff_tile_array : Array = []
var terrain_cliff_int = 0

var patch_decor_array : Array = [Vector2i(19,2), Vector2i(21,2), Vector2i(20,3),]
var tree_atlas_array : Array = [Vector2i(0,24), Vector2i(4,24), Vector2i(0,24), Vector2i(4,24), Vector2i(4,30), Vector2i(4,31), Vector2i(4,32)]

func _ready() -> void:
	noise = noise_height_text.noise
	tree_noise = noise_tree_text.noise
	noise.seed = randi_range(1,1000)
	generate_world()

func generate_world():
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_val = noise.get_noise_2d(x,y)
			var tree_noise_val = tree_noise.get_noise_2d(x,y)
			if noise_val >= -0.3:
				if noise_val > 0.0 and noise_val < 0.1 and tree_noise_val > 0.6:
					environment.set_cell(Vector2i(x,y), source_id, tree_atlas_array.pick_random())
				snow_tile_array.append(Vector2i(x,y))
				if noise_val >= -0.3:
					snow_patch_tile_array.append(Vector2i(x,y))
					if noise_val > 0.12:
						patch_decor.set_cell(Vector2i(x,y), source_id, patch_decor_array.pick_random())
					if noise_val >= 0.2:
						cliff_tile_array.append(Vector2i(x,y))
			if noise_val < -0.3:
				water.set_cell(Vector2(x,y), source_id, water_atlas)
	
	set_player_base()
	snow_water.set_cells_terrain_connect(snow_tile_array, terrain_snow_int, 0)
	snow_patch.set_cells_terrain_connect(snow_patch_tile_array, terrain_snow_patch_int, 2)
	cliffs.set_cells_terrain_connect(cliff_tile_array, terrain_cliff_int, 1)
	generate_debris()
	generate_debris_piles()
	generate_deposit_stations()

var circle_radius: int = 4  # Radius of the circle in tiles
var center_position: Vector2i= Vector2i(0, 0) # Center of the circle in tile coordinates
var tile_id: int = 0 # ID of the tile to place

func set_player_base():
	for x in range(center_position.x - circle_radius, center_position.x + circle_radius + 1):
		for y in range(center_position.y - circle_radius, center_position.y + circle_radius + 1):
			var current_cell = Vector2i(x, y)
			if current_cell.distance_to(center_position) <= circle_radius:
				if snow_tile_array.has(current_cell):
					snow_tile_array.remove_at(snow_tile_array.find(current_cell))
				if snow_patch_tile_array.has(current_cell):
					snow_patch_tile_array.remove_at(snow_patch_tile_array.find(current_cell))
				if cliff_tile_array.has(current_cell):
					cliff_tile_array.remove_at(cliff_tile_array.find(current_cell))
				snow_patch.set_cell(current_cell, source_id, Vector2i(20, 2))

@export var debris_count : int = 200
func generate_debris():
	debris_count = randi_range(180, 240)
	for i in range(debris_count):
			var current_cell = snow_patch_tile_array.pick_random()
			var current_cell_pos : Vector2 = current_cell * 32
			spawn_debris(current_cell_pos)
			snow_patch_tile_array.remove_at(snow_patch_tile_array.find(current_cell))

var debris_scene : PackedScene = preload("res://debris/debris.tscn")
#var debris_plane = get_parent().find_child("DebrisField")
func spawn_debris(debris_position):
	var new_debris : Carryable = debris_scene.instantiate()
	new_debris.z_index = 2
	#new_debris.scale = Vector2(15,15)
	new_debris.scrap_type = check_debris_value(debris_position)
	add_child(new_debris)
	new_debris.global_position = debris_position

var gold_max : int = 8
var spirit_max : int = 20

var silver_threshhold = 3200
var spirit_threshhold = 4700
var gold_threshhold = 5300

func check_debris_value(target_position : Vector2):
	var type : String = "rusty"
	var dist = target_position.distance_to(Vector2(0,0))
	if dist >= silver_threshhold:
		type = "silver"
	if dist >= spirit_threshhold and spirit_threshhold > 0:
		if randi_range(0,1) == 1:
			type = "spirit"
			spirit_max -= 1
	if dist >= gold_threshhold and gold_max > 0:
		if randi_range(0,3) == 1:
			type = "gold"
			gold_max -= 1
		else:
			type = "spirit"
	return type

@export var debris_pile_count : int = 30
func generate_debris_piles():
	debris_pile_count = randi_range(25, 35)
	for i in range(debris_pile_count):
			var current_cell = snow_patch_tile_array.pick_random()
			var current_cell_pos : Vector2 = current_cell * 32
			var dist = current_cell_pos.distance_to(Vector2(0,0))
			if dist >= 2000:
				spawn_debris_pile(current_cell_pos)
				snow_patch_tile_array.remove_at(snow_patch_tile_array.find(current_cell))

var debris_pile_scene : PackedScene = preload("res://debris_pile/debris_pile.tscn")
func spawn_debris_pile(debris_pile_position):
	var new_debris_pile = debris_pile_scene.instantiate()
	new_debris_pile.z_index = 2
	#new_debris_pile.scale = Vector2(15,15)
	new_debris_pile.debris_type = check_pile_value(debris_pile_position)
	add_child(new_debris_pile)
	new_debris_pile.global_position = debris_pile_position

var pile_gold_max : int = 3
var pile_spirit_max : int = 10

var pile_silver_threshhold = 3800
var pile_spirit_threshhold = 4800
var pile_gold_threshhold = 5600

func check_pile_value(target_position : Vector2):
	var type : String = "rusty"
	var dist = target_position.distance_to(Vector2(0,0))
	if dist >= pile_silver_threshhold:
		type = "silver"
	if dist >= pile_spirit_threshhold and pile_spirit_max > 0:
		if randi_range(0,2) == 1:
			type = "spirit"
			pile_spirit_max -= 1
	if dist >= pile_gold_threshhold and pile_gold_max > 0:
		if randi_range(0,3) == 1:
			type = "gold"
			pile_gold_max -= 1
	return type

@export var deposit_station_count : int = 8
func generate_deposit_stations():
	spawn_deposit_stations(Vector2(0,-20))
	for i in range(deposit_station_count):
			var current_cell = snow_patch_tile_array.pick_random()
			var current_cell_pos : Vector2 = current_cell * 32
			var dist = current_cell_pos.distance_to(Vector2(0,0))
			if dist >= 2000:
				spawn_deposit_stations(current_cell_pos)
				snow_patch_tile_array.remove_at(snow_patch_tile_array.find(current_cell))

var deposit_station_scene : PackedScene = preload("res://dropoff_spots/dropoff_spot.tscn")
func spawn_deposit_stations(deposit_station_position):
	var new_deposit_station = deposit_station_scene.instantiate()
	new_deposit_station.z_index = 2
	#new_deposit_station.scale = Vector2(15,15)
	add_child(new_deposit_station)
	new_deposit_station.global_position = deposit_station_position
