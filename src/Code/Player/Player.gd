extends KinematicBody2D
class_name Player


signal moved
signal stopped
signal jumped
signal landed
signal shot
signal direction_changed


export(float, 0, 1000, 10) var acceleration: float = 300.0
export(float, 0, 1, 0.025) var damping: float = 0.80
export(float, 0, 1000, 10) var max_speed: float = 400.0
export(float, 0, 200, 10) var gravity: float = 50.0
export(float, 0, 2000, 25) var jump_strength: float = 300.0
export(float, 0, 100, 1) var shoot_cost: float = 30


onready var bullet_tscn = preload("res://Code/Player/Bullet/Bullet.tscn")


var move_dir: Vector2 = Vector2()
var look_dir: Vector2 = Vector2()
var vel: Vector2 = Vector2()

var last_jump_time = 0
var jump_buffer_msecs = 100
var last_shoot_time = 0
var shoot_buffer_msecs = 100
var was_on_floor = false
var charge = 0 setget _set_charge


func _physics_process(delta):
	look_dir = _get_dir_to_mouse()
	$aimer.rotation = look_dir.angle()
	
	_move_player()


func _input(event):
	if event.is_action_pressed("jump") and event.is_pressed():
		last_jump_time = OS.get_system_time_msecs()
	if event.is_action_pressed("shoot") and event.is_pressed():
		last_shoot_time = OS.get_system_time_msecs()
		if _can_shoot():
			shoot()
		

func shoot():
	_set_charge(charge - shoot_cost)
	var bul = bullet_tscn.instance()
	bul.global_position = $aimer/offset.global_position
	bul.global_rotation = $aimer.global_rotation
	get_parent().add_child(bul)
	emit_signal("shot")


func jump():
	vel.y = -jump_strength
	last_jump_time = 0
	emit_signal("jumped")


func _move_player() -> void:
	var move_dir = _get_input_dir()
	vel += move_dir * acceleration
	vel.x = clamp(vel.x, -max_speed, max_speed)
	
	vel += Vector2(0, gravity) # gravity
	
	vel = move_and_slide(vel, Vector2(0,-1))
	vel.x *= damping
	
	if not was_on_floor and is_on_floor():
		emit_signal("landed")
	was_on_floor = is_on_floor()
	
	if _can_jump():
		jump()
	
	if move_dir.dot(vel) < 0: emit_signal("direction_changed")
	if not move_dir.is_equal_approx(Vector2()): 
		_set_charge(charge + 1)
		emit_signal("moved")
	else: emit_signal("stopped")


func _set_charge(v):
	charge = clamp(v, 0, 100)


func _can_shoot() -> bool:
	return charge >= shoot_cost and _is_shoot_just_pressed()
	

func _can_jump() -> bool:
	return is_on_floor() and _is_jump_just_pressed()


func _get_input_dir() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		0 #Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

func _get_dir_to_mouse() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()

func _is_jump_just_pressed() -> bool:
	return OS.get_system_time_msecs() - last_jump_time < jump_buffer_msecs

func _is_shoot_just_pressed() -> bool:
	return OS.get_system_time_msecs() - last_shoot_time < shoot_buffer_msecs
