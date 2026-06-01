extends CharacterBody2D

var speed: float = 125.0
var idle_speed: float = 62.5
var flee_distance: float = 300.0
var noise_intensity: float = 0.3
var rotation_speed: float = 5.0

var player: CharacterBody2D
var move_direction: Vector2
var energy = 10

var alive_time := 0.0
var can_be_eaten := false
var activation_delay := 1.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	randomize()
	set_random_position()
	rotation_degrees = randi() % 360
	move_direction = Vector2.RIGHT.rotated(randf_range(0.0, TAU))

func set_random_position():
	global_position = Vector2(
		randf_range(-1900, 1900),
		randf_range(-1900, 1900)
	)

func _physics_process(delta: float):
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance < flee_distance:

		var flee_direction = (global_position - player.global_position).normalized()

		var noise = Vector2(
			randf_range(-noise_intensity, noise_intensity),
			randf_range(-noise_intensity, noise_intensity)
		)

		move_direction = (flee_direction + noise).normalized()
		velocity = move_direction * speed

	else:
		velocity = move_direction * idle_speed

	move_and_slide()

	if velocity.length() > 0.0:
		var target_angle = velocity.angle() + PI / 2

		rotation = lerp_angle(
			rotation,
			target_angle,
			rotation_speed * delta
		)
	if abs(global_position.x) > 2000 or abs(global_position.y) > 2000:
		queue_free()
		
	alive_time += delta
	if alive_time >= activation_delay:
		can_be_eaten = true
