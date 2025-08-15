extends Camera2D

var follow_dist : float = 50.0
var following : bool = true

func _physics_process(delta: float) -> void:
	if following:
		follow()

func follow():
	var dir = get_direction()
	position = position.lerp(dir * follow_dist, 0.04)

func get_direction():
	var input : Vector2 = Vector2()
	if Input.is_action_pressed("Move_Up"):
		input.y -=1
	if Input.is_action_pressed("Move_Down"):
		input.y +=1
	if Input.is_action_pressed("Move_Left"):
		input.x -=1
	if Input.is_action_pressed("Move_Right"):
		input.x +=1
	return input

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		zoom *= 1.2
	if event.is_action_pressed("ui_down"):
		zoom /= 1.2
