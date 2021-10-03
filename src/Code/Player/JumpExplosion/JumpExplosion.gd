extends Area2D


func _ready():
	$AnimatedSprite.play("Idle")
	yield($AnimatedSprite, "animation_finished")
	queue_free()


func _on_JumpExplosion_body_entered(body):
	if body.has_method("break_tile") and body is TileMap:
		for point in $points.get_children():
			body.break_tile(point.global_position)
	
	if body.has_method("hurt"):
		body.hurt()

