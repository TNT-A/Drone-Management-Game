extends Node2D

@onready var lower_notif: Label = $CenterContainer/LowerNotif
@onready var major_notif: Label = $CenterContainer2/MajorNotif

#var minor_notif_active : bool = false
#var major_notif_active : bool = false

func _ready() -> void:
	SignalBus.minor_notif.connect(notify)
	SignalBus.major_notif.connect(major_notify)
	#notify("I swerve in the corner", 5.0)
	#major_notify("I swerve in the corner", 5.0)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("Left_Click"):
		#notify("You Clicked!", 2.0)
	#if event.is_action_pressed("Right_Click"):
		#major_notify("You Right Clicked!", 2.0)

func notify(notif_text, length):
	lower_notif.text = notif_text
	$MinorAnimationPlayer.play("pop_up")
	$MinorTimer.wait_time = length
	$MinorTimer.start()

func major_notify(notif_text, length):
	major_notif.text = notif_text
	$MajorAnimationPlayer.play("pop_up")
	$MajorTimer.wait_time = length
	$MajorTimer.start()

func _on_minor_timer_timeout() -> void:
	$MinorAnimationPlayer.play("pop_down")

func _on_major_timer_timeout() -> void:
	$MajorAnimationPlayer.play("pop_down")
