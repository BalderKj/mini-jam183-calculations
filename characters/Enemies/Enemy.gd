class_name Enemy
extends CharacterBody2D

@export var stats: EnemyStats

@onready var enemy_legs: AnimatedSprite2D = $"enemy legs"
@onready var enemy_top: AnimatedSprite2D = $enemyTop

var knockback_force: Vector2 = Vector2.ZERO
var health: float
var damage: int
var speed: float
var target : Node2D


func _ready() -> void:
	if stats:
		apply_stats()
	target = get_tree().get_first_node_in_group("player")
	

		
func apply_stats():
	speed = stats.speed
	health = stats.health
	damage = stats.damage
	
	
func _physics_process(_delta):
	if not target:
		return
		
	var direction = (target.global_position - global_position).normalized()
	var move_velocity = direction * speed
	
	velocity = move_velocity + knockback_force
	move_and_slide()
	update_animation(direction)
	
	knockback_force = knockback_force.move_toward(Vector2.ZERO, 1000 * _delta)

func update_animation(direction: Vector2) -> void:
	var enum_name: String = EnemyStats.types.keys()[stats.type].to_lower()
	if direction == Vector2.ZERO:
		enemy_legs.play("enemy_idle")
		return
	if direction.y != 0:
		enemy_legs.play("enemy_run")
	if direction.x != 0:
		enemy_legs.play("enemy_run")
		enemy_legs.flip_h = direction.x < 0
		
	elif not enemy_legs.is_playing():
		enemy_legs.play()
	enemy_top.play(enum_name + "_bob")

func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO):
	
	if knockback != Vector2.ZERO:
		knockback_force += knockback
	
	health -= amount
	damage_effect()
	
	
	if health <= 0:
		queue_free()
		#more death logic here
	
	
func damage_effect():
	var tween = create_tween()
	enemy_top.modulate = Color(2, 2, 2) 
	tween.tween_property(enemy_top, "modulate", Color(1,1,1), 0.15)
