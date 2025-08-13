extends Area2D

var player_here : bool = false

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		SignalBus.dropoff.emit(self)
		player_here = true
		$Timer.start()

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		player_here = false
		$Timer.stop()

func _on_timer_timeout() -> void:
	if player_here:
		SignalBus.dropoff.emit(self)
