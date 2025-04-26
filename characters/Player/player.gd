extends CharacterBody2D


@export var move_speed: float = 200.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon: Node2D = $Weapon

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	weapon.look_at(mouse_pos)
	if Input.is_action_pressed("fire"):
		weapon.fire()
		
func _physics_process(_delta: float) -> void:
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	input_vector.y = Input.get_action_strength("s") - Input.get_action_strength("w")
	input_vector = input_vector.normalized()
	
	velocity = input_vector * move_speed
	
	move_and_slide()
	position = position.round()
	
	_update_animation(input_vector)

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
		
