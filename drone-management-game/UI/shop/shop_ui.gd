extends Control

@onready var drone_label: Label = $HFlowContainer/CenterContainer/VBoxContainer/HBoxContainer/ButtonDrone/Label
@onready var money_label: Label = $HFlowContainer/CenterContainer2/Label

@onready var weight_price_label: Label = $HFlowContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/Label
@onready var weight_level_label: Label = $HFlowContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/Label

@onready var speed_price_label: Label = $HFlowContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer2/Label
@onready var speed_level_label: Label = $HFlowContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer2/HBoxContainer/Label
@onready var value_price_label: Label = $HFlowContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer3/Label
@onready var value_level_label: Label = $HFlowContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Label
@onready var damage_price_label: Label = $HFlowContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer4/Label
@onready var damage_level_label: Label = $HFlowContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer4/HBoxContainer/Label

var base_money_label : String 

#var game_manager.scrap : int = 1000

var level_max : int = 5

var weight_level : int = 1
var speed_level : int = 1
var value_level : int = 1
var damage_level : int = 1

var drone_level : int = 1

var drone_level_prices : Array[int] = [
	10,
	25,
	50,
	75,
]

var reg_level_prices : Array[int] = [
	3,
	8, 
	15,
	25
]

var game_manager
func _ready() -> void:
	SignalBus.shop_opened.connect(open_shop)
	SignalBus.shop_closed.connect(close_shop)
	game_manager = get_parent().get_parent()
	base_money_label = money_label.text
	set_money()

func open_shop():
	set_money()
	visible = true
	$AnimationPlayer.play("slide_down")

func close_shop():
	#visible = false
	$AnimationPlayer.play("slide_up")

func set_money():
	money_label.text = base_money_label + str(game_manager.scrap) + " Scrap"

func _on_button_drone_pressed() -> void:
	if drone_level < level_max:
		var current_price = drone_level_prices[drone_level - 1]
		if game_manager.scrap >= current_price:
			drone_level += 1
			game_manager.scrap -= current_price
			SignalBus.drone_upgraded.emit()
			if drone_level < level_max:
				current_price = drone_level_prices[drone_level - 1]
				drone_label.text = str(current_price) + " Scrap"
			else:
				drone_label.text = "MAX"
			set_money()
		else: 
			SignalBus.minor_notif.emit("I can't afford that!")

func _on_button_weight_pressed() -> void:
	if weight_level < level_max:
		var current_price = reg_level_prices[weight_level - 1]
		if game_manager.scrap >= current_price:
			weight_level += 1
			game_manager.scrap -= current_price
			SignalBus.weight_upgraded.emit()
			if weight_level < level_max:
				current_price = reg_level_prices[weight_level - 1]
				weight_price_label.text = "Price: " + str(current_price) + " Scrap"
			else:
				weight_price_label.text = "MAX"
			weight_level_label.text = "LV." + str(weight_level)
			set_money()
		else: 
			SignalBus.minor_notif.emit("I can't afford that!")

func _on_button_speed_pressed() -> void:
	if speed_level < level_max:
		var current_price = reg_level_prices[speed_level - 1]
		if game_manager.scrap >= current_price:
			speed_level += 1
			game_manager.scrap -= current_price
			SignalBus.speed_upgraded.emit()
			if speed_level < level_max:
				current_price = reg_level_prices[speed_level - 1]
				speed_price_label.text = "Price: " + str(current_price) + " Scrap"
			else:
				speed_price_label.text = "MAX"
			speed_level_label.text = "LV." + str(speed_level)
			set_money()
		else: 
			SignalBus.minor_notif.emit("I can't afford that!")

func _on_button_value_pressed() -> void:
	if value_level < level_max:
		var current_price = reg_level_prices[value_level - 1]
		if game_manager.scrap >= current_price:
			value_level += 1
			game_manager.scrap -= current_price
			SignalBus.value_upgraded.emit()
			if value_level < level_max:
				current_price = reg_level_prices[value_level - 1]
				value_price_label.text = "Price: " + str(current_price) + " Scrap"
			else:
				value_price_label.text = "MAX"
			value_level_label.text = "LV." + str(value_level)
			set_money()
		else: 
			SignalBus.minor_notif.emit("I can't afford that!")

func _on_button_damage_pressed() -> void:
	if damage_level < level_max:
		var current_price = reg_level_prices[damage_level - 1]
		if game_manager.scrap >= current_price:
			damage_level += 1
			game_manager.scrap -= current_price
			SignalBus.damage_upgraded.emit()
			if damage_level < level_max:
				current_price = reg_level_prices[damage_level - 1]
				damage_price_label.text = "Price: " + str(current_price) + " Scrap"
			else:
				damage_price_label.text = "MAX"
			damage_level_label.text = "LV." + str(damage_level)
			set_money()
		else: 
			SignalBus.minor_notif.emit("I can't afford that!")

var win_price = 250
func _on_button_win_pressed() -> void:
	if game_manager.scrap >= win_price:
		SignalBus.win_game.emit()
	else: 
		SignalBus.minor_notif.emit("I can't afford that!")
