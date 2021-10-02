extends KinematicBody2D


export(float, 0, 1000, 20) var speed: float = 100


var move_dir: Vector2 = Vector2()
var up_dir: Vector2 = Vector2()


func _ready():
	$Sprite.play("Walk")


func _physics_process(delta):
	up_dir = Vector2(0, -1).rotated(rotation)
	move_dir = Vector2(1,0).rotated(rotation)
	move_and_slide_with_snap(move_dir * speed, up_dir)
	
	if can_turn():
		turn()


func turn():
	scale.x *= -1
	pass


func can_turn():
	return ((not $rays/front.is_colliding() and $rays/back.is_colliding()) or 
			($rays/face.is_colliding()))


func hurt(): # get's called by the bullet on collision
	queue_free()


#func _draw():
#	var f = Control.new().get_font("default")
#	draw_string(f, Vector2(30,0), str($rays/front.is_colliding()))
#	draw_string(f, Vector2(30,30), str($rays/face.is_colliding()))
