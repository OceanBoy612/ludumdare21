extends KinematicBody2D


export var speed = 100


func _physics_process(delta):
	var col: KinematicCollision2D = move_and_collide(Vector2(speed,0).rotated(rotation))
	if col:
		die()
	


func die():
	queue_free()


func _on_Timer_timeout():
	die()
