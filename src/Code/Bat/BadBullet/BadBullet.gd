extends KinematicBody2D


export var speed = 150
var direction = Vector2(0,0)


func _physics_process(delta):
#	$Sprite.rotate(delta * deg2rad(rotation_speed))
	var col: KinematicCollision2D = move_and_collide(direction*delta*speed)
	if col:
#		if col.collider.has_method("break_tile"):
#			col.colliwder.break_tile(col)
#		if col.collider.has_method("hurt"):
#			col.collider.hurt(1, direction)
		die()
	


func die():
#	var expl = med_expl_tscn.instance()
#	expl.global_position = global_position
#	get_parent().add_child(expl)
	
	queue_free()


func _on_Timer_timeout():
	die()
