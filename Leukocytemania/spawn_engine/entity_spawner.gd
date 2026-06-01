extends Node

@export var entities : Array[EntityData] = []

var spawn_rate : float = 1.0
var spawn_accumulator : float = 0.0
var time_elapsed : float = 0.0
var total_weight : float = 0.0
var alive_counts: Dictionary = {}

func _ready():
	total_weight = 0.0
	for data in entities:
		if data.rarity <= 0.0:
			push_error("rarity debe ser mayor a 0 en todos los ataques")
		total_weight += 1.0 / data.rarity
		alive_counts[data.scene] = 0
		
func _process(delta: float):
	if entities.size() == 0:
		return
		
	time_elapsed += delta
	spawn_rate = 1000.0 + (time_elapsed * 0.1)
	spawn_accumulator += spawn_rate * delta
	var to_spawn : int = int(floor(spawn_accumulator))
	
	if to_spawn > 0:
		spawn_accumulator -= to_spawn
		for i in to_spawn:
			spawn_entity()
			
func spawn_entity():
	var data = pick_entity_data()
	if data == null:
		return

	# CAP CHECK
	if alive_counts[data.scene] >= data.max_alive:
		return

	var instance = data.scene.instantiate()
	add_child(instance)

	alive_counts[data.scene] += 1
	instance.tree_exited.connect(_on_entity_removed.bind(data.scene))
	
func pick_entity_data() -> EntityData:
	if total_weight <= 0.0:
		return null
	var r := randf() * total_weight
	var cumulative := 0.0
	
	for data in entities:
		cumulative += 1.0 / data.rarity
		if r <= cumulative:
			return data
	return null
	
func _on_entity_removed(scene: PackedScene):
	if alive_counts.has(scene):
		alive_counts[scene] = max(alive_counts[scene] - 1, 0)
