extends Node2D
class_name Player

var speed = 200

func _ready() -> void:
	await get_parent().get_parent().ready
	SignalBus.register_player.emit(self)
	SignalBus.speed_upgraded.connect(upgrade_speed)

func upgrade_speed():
	speed += 50

func _on_notifier_trigger_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.owner is Carryable:
		SignalBus.minor_notif.emit("I should lead my drones to that metal scrap", 3.0)
