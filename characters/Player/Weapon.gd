extends Node2D

@export var weapon_data: WeaponData
@export var fire_cooldown: float = 0.0

var time_since_last_shot: float = 0.0

func _process(delta: float) -> void:
	time_since_last_shot += delta

func fire():
	if time_since_last_shot >= fire_cooldown:
		time_since_last_shot = 0.0
		fire_cooldown = 1.0 / weapon_data.fire_rate
		for i in weapon_data.shots_per_burst:
			var projectile = weapon_data.projectile_scene.instantiate()
			get_tree().current_scene.add_child(projectile)
			projectile.global_position = global_position
			projectile.rotation = rotation + randf_range(-weapon_data.spread, weapon_data.spread)
			projectile.damage = weapon_data.damage
			#projectile.direction = (get_global_mouse_position() - global_position).normalized()
