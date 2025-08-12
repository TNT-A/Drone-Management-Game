extends Control

func _on_button_back_pressed() -> void:
	back()

func _on_button_settings_pressed() -> void:
	settings()

func _on_button_menu_pressed() -> void:
	menu()

func _on_button_sure_pressed() -> void:
	sure()

func _on_button_back_to_pause_pressed() -> void:
	$MenuList.visible = true
	$MenuSure.visible = false

func back():
	SignalBus.emit_signal("pause_changed")

func settings():
	print("I have no settings yet :(")

func menu():
	$MenuList.visible = false
	$MenuSure.visible = true

func sure():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
