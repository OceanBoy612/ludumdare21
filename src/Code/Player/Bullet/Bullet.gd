extends KinematicBody2D


export var speed = 100
export var rotation_speed = 15 



func _physics_process(delta):
	$Sprite.rotate(delta * deg2rad(rotation_speed))
	var col: KinematicCollision2D = move_and_collide(Vector2(speed,0).rotated(rotation))
	if col:
		if col.collider.has_method("hurt"):
			col.collider.hurt()
		die()
	


func die():
	queue_free()


func _on_Timer_timeout():
	die()
