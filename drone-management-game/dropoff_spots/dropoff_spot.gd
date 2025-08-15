extends Node2D

var shop_opened
var in_shop_area : bool = false 

func _on_shop_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		SignalBus.major_notif.emit("Press E to Open Shop.", 3.0)
		in_shop_area = true
		scale = Vector2(1.1,1.1)

func _on_shop_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		in_shop_area = false
		scale = Vector2(1,1)
		if shop_opened:
			SignalBus.shop_closed.emit()
			shop_opened = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and !shop_opened:
		SignalBus.shop_opened.emit()
		shop_opened = true
	elif event.is_action_pressed("interact") and shop_opened:
		SignalBus.shop_closed.emit()
		shop_opened = false
