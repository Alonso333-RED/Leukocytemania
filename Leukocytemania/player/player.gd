extends CharacterBody2D

var speed = 250

var min_x = -1900
var max_x = 1900
var min_y = -1900
var max_y = 1900

var move_input := Vector2.ZERO

var energy = 100
var consumption = 0.0

@onready var energy_bar = $"../GameUi/Control/VBoxContainer/energy_bar"

func _ready():
	energy_bar.value = energy
	
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
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body.is_in_group("eatable") and body.can_be_eaten:
			energy += body.energy
			if energy > 100:
				energy = 100
			print(energy)
			body.queue_free()

func set_move_input(v: Vector2):
	move_input = v

func _on_timer_timeout() -> void:
	energy -= consumption
	if energy <= 0:
		get_tree().change_scene_to_file("res://game/Game.tscn")
	energy_bar.value = energy
	consumption += 0.1
