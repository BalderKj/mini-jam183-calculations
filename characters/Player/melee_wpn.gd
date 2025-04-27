extends Node2D

@export var damage: int = 20
@export var knockback_power: float = 300.0
@export var sword_area: Area2D
@export var orbit_radius: float = 20.0
@export var can_attack: bool = true


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $SwordArea/Sprite2D


func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var player_pos = get_parent().global_position
	var vector_to_mouse = mouse_pos - player_pos
	
	
	if vector_to_mouse.length() > orbit_radius * 2:
		var direction = (mouse_pos - global_position).normalized()
		global_position = get_parent().global_position + direction * orbit_radius
		look_at(mouse_pos)
	
func fire():
	if can_attack:
		animation_player.play("sword_anim")
		

func _on_sword_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		var direction = (body.global_position - global_position).normalized()
		var knockback = direction * knockback_power
		body.take_damage(damage, knockback)
