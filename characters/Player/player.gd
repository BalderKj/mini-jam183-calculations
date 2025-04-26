extends CharacterBody2D


@export var move_speed: float = 200.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon: Node2D = $Weapon
@onready var game_over_menu: Control = $GameOverMenu

@export var max_health := 100
@export var i_frame_duration: float = 0.5

var overlapping_enemies: Array = []
var invincible_timer: float = 0.0

var healthpoints: int = max_health:
	set(value):
		var clamped = clamp(value, 0, max_health)
		if clamped < healthpoints:
			damage_effect()
		healthpoints = clamped
		if healthpoints <= 0:
			game_over_menu.game_over()

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	weapon.look_at(mouse_pos)
	if Input.is_action_pressed("fire"):
		weapon.fire()
		
func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	input_vector.y = Input.get_action_strength("s") - Input.get_action_strength("w")
	input_vector = input_vector.normalized()
	
	velocity = input_vector * move_speed
	
	move_and_slide()
	position = position.round()
	_update_animation(input_vector)
	update_invincibility(delta)
	if invincible_timer <= 0.0:
		check_enemy_collisions()

func _update_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		anim_sprite.animation = "player_idle"
		return
	if direction.y != 0:
		anim_sprite.animation = "player_run"
		anim_sprite.play()
		
	if direction.x != 0:
		anim_sprite.animation = "player_run"
		anim_sprite.flip_h = direction.x < 0
		anim_sprite.play()
		
	elif not anim_sprite.is_playing():
		anim_sprite.play()
		
func update_invincibility(delta):
	if invincible_timer > 0.0:
		invincible_timer -= delta
func check_enemy_collisions():
	for enemy in overlapping_enemies:
		if enemy.is_inside_tree():
			print("player health = " + str(healthpoints) )
			healthpoints -= enemy.damage
			invincible_timer = i_frame_duration
			break # to prevent more than 1 hit per invincibility cycle

func damage_effect():
	var tween = create_tween()
	anim_sprite.modulate = Color(2, 2, 2) 
	tween.tween_property(anim_sprite, "modulate", Color(1,1,1), 0.15)
	

	


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and body not in overlapping_enemies:
		overlapping_enemies.append(body)

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and body in overlapping_enemies:
		overlapping_enemies.erase(body)
