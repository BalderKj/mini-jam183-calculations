extends Area2D

@export var speed: float = 500.0
var damage: int
var direction: Vector2 = Vector2.ZERO
var lifetime := 1.5 #seconds

func _process(delta):
	global_position += Vector2.RIGHT.rotated(rotation) * speed * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
