extends CharacterBody2D

var speed = 250
var detection_range = 500.0
var detection_range_sq = detection_range * detection_range

var target: Node2D = null

var energy = 100

var can_eat := false
var alive_time := 0.0
var activation_delay := 0.5

var search_timer := 0.0
var search_interval := 0.25

var min_x = -2000
var max_x = 2000
var min_y = -2000
var max_y = 2000

var info_flag: String = "leukocyte"

func _ready():
	randomize()
	global_position = Vector2(
		randf_range(min_x, max_x),
		randf_range(min_y, max_y)
	)


func _physics_process(delta):

	if global_position.x < min_x or global_position.x > max_x \
	or global_position.y < min_y or global_position.y > max_y:
		queue_free()
		return

	search_timer += delta
	if search_timer >= search_interval:
		search_timer = 0.0

		if target == null or not is_instance_valid(target):
			find_target()

	if target != null and is_instance_valid(target):
		var dir = (target.global_position - global_position).normalized()
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body == null:
			continue

		if body.is_in_group("eatable") and body.can_be_eaten:
			energy = min(energy + body.energy, 100)
			body.queue_free()
			target = null

	if not can_eat:
		alive_time += delta
		if alive_time >= activation_delay:
			can_eat = true


func find_target():
	var closest = null
	var closest_dist = detection_range_sq

	for node in get_tree().get_nodes_in_group("eatable"):

		if node == null:
			continue

		if not is_instance_valid(node):
			continue

		if not ("can_be_eaten" in node):
			continue

		if not node.can_be_eaten:
			continue

		var dist = global_position.distance_squared_to(node.global_position)

		if dist < closest_dist:
			closest = node
			closest_dist = dist

	target = closest
