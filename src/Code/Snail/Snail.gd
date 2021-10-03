extends KinematicBody2D


export(float, 0, 1000, 20) var speed: float = 100


var move_dir: Vector2 = Vector2()
var up_dir: Vector2 = Vector2()
var damage: float = 1.0


func _ready():
	add_to_group("enemies")
	$Sprite.play("Walk")


func _physics_process(delta):
	up_dir = Vector2(0, -1).rotated(rotation)
	move_dir = Vector2(1,0).rotated(rotation)
	move_and_slide_with_snap(move_dir * speed, up_dir)
	
	for i in get_slide_count():
		var col: KinematicCollision2D = get_slide_collision(i)
		if col and col.collider.has_method("hurt"):
			col.collider.hurt(1, -1*col.normal)
			break
	
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
