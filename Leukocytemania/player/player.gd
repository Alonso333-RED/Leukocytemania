extends CharacterBody2D

var speed = 250

var min_x = -450
var max_x = 450
var min_y = -450
var max_y = 450

var move_input := Vector2.ZERO

@warning_ignore("unused_parameter")
func _physics_process(delta):
	var input_vector := Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if move_input.length() > 0.1:
		input_vector = move_input

	if input_vector.length() > 0.1:
		velocity = input_vector.normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.y = clamp(global_position.y, min_y, max_y)

func set_move_input(v: Vector2):
	move_input = v
