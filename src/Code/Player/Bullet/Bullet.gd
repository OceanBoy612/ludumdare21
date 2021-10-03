extends KinematicBody2D


export var speed = 100
export var rotation_speed = 15 


onready var med_expl_tscn = preload("res://Code/Effects/ExplosionEffectMedium.tscn")


func _physics_process(delta):
	$Sprite.rotate(delta * deg2rad(rotation_speed))
	var col: KinematicCollision2D = move_and_collide(Vector2(speed,0).rotated(rotation))
	if col:
		if col.collider.has_method("break_tile"):
			col.collider.break_tile(col)
		if col.collider.has_method("hurt"):
			col.collider.hurt()
		die()
	


func die():
	var expl = med_expl_tscn.instance()
	expl.global_position = global_position
	get_parent().add_child(expl)
	
	queue_free()


func _on_Timer_timeout():
	die()
