extends KinematicBody2D

export(float, 0, 1000, 20) var speed: float = 100

var move_dir: Vector2 = Vector2()
var up_dir: Vector2 = Vector2()
var damage: float = 1.0
enum {MOVE, ATTACK}
var state = MOVE
var shoot_timer = 0
var shoot_time = 2

onready var bullet_tscn = preload("res://Code/Bat/BadBullet/BadBullet.tscn")

func _ready():
	add_to_group("enemies")
	$Sprite.play("Walk")

func _physics_process(delta):
	match state:
		MOVE:
			move()
		ATTACK:
			attack()
	if shoot_timer > shoot_time:
		shoot_timer = 0
		state = ATTACK
	else:
		shoot_timer += delta

func move():
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

func attack():
	var player_node = get_parent().get_node("Player")
	if player_node:
		var bul = bullet_tscn.instance()
		bul.global_position = global_position
		bul.direction = global_position.direction_to(player_node.global_position)
		print(bul.direction)
		get_parent().add_child(bul)
	state = MOVE

func turn():
	scale.x *= -1
	pass


func can_turn():
	return ((not $rays/front.is_colliding() and $rays/back.is_colliding()) or
			($rays/face.is_colliding()))


func hurt(): # get's called by the bullet on collision
	queue_free()
