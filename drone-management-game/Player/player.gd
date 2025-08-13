extends Node2D
class_name Player

func _ready() -> void:
	await get_parent().get_parent().ready
	SignalBus.register_player.emit(self)
