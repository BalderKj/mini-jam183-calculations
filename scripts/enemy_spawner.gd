extends Node

@export var enemy_scene: PackedScene
@export var spawn_entries: Array[EnemySpawnEntry]
@export var enemies_per_wave: int = 10
@export var time_between_waves: float = 5.0
@export var spawn_radius: float = 300.0


var wave_timer := 0.0
var current_wave := 0

func _process(delta):
	wave_timer -= delta
	if wave_timer <= 0.0:
		start_wave()
		wave_timer = time_between_waves
		
func start_wave():
	current_wave += 1
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	
	for i in enemies_per_wave:
		var stats_entry = get_random_stats_entry()
		if stats_entry == null:
			continue
		
		var enemy = enemy_scene.instantiate()
		enemy.global_position = player.global_position + get_random_spawn_offset()
		enemy.stats = stats_entry.stats
		get_tree().current_scene.add_child(enemy)
		
func get_random_stats_entry() -> EnemySpawnEntry:
	var valid_entries = []
	for entry in spawn_entries:
		if current_wave >= entry.min_wave:
			for i in entry.spawn_weight:
				valid_entries.append(entry)
	return valid_entries.pick_random() if valid_entries.size () > 0 else null
	
func get_random_spawn_offset() -> Vector2:
	var angle = randf_range(0, TAU)
	return Vector2.RIGHT.rotated(angle) * spawn_radius
