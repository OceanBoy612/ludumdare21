extends KinematicBody2D
class_name Player


signal moved
signal stopped
signal jumped
signal landed
signal shot
signal died
signal health_changed
signal charge_changed
signal direction_changed


export(float, 0, 1000, 10) var acceleration: float = 300.0
export(float, 0, 1, 0.025) var damping: float = 0.80
export(float, 0, 1000, 10) var max_speed: float = 400.0
export(float, 0, 200, 10) var gravity: float = 50.0
export(float, 0, 2000, 25) var jump_strength: float = 300.0
export(float, 0, 100, 1) var shoot_cost: float = 30
export(float, 0, 1000, 25) var knockback_strength: float = 250
export(float, 0, 1, 0.05) var knockback_decay: float = 0.5
export(float, 0, 1000, 25) var hurt_knockback_strength: float = 200
export(float, 0, 20, 1) var max_health: float = 3


onready var bullet_tscn = preload("res://Code/Player/Bullet/Bullet.tscn")
onready var muzzleEffect = preload("res://Code/Effects/FlashEffect.tscn") #MrGeko
onready var lid_tscn = preload("res://Code/Player/Lid/Lid.tscn")

var move_dir: Vector2 = Vector2()
var look_dir: Vector2 = Vector2()
var vel: Vector2 = Vector2()
var knockback: Vector2 = Vector2()

var immortal = false
var last_jump_time = 0
var jump_buffer_msecs = 100
var last_shoot_time = 0
var shoot_buffer_msecs = 100
var was_on_floor = false
var last_on_floor_time = 0
var coyote_time_buffer = 100
var charge = 0 setget _set_charge
var health = 0 setget _set_health
var is_dead = false


func _ready():
	_set_health(max_health)
	_set_charge(0)


func _physics_process(delta):
	look_dir = _get_dir_to_mouse()
	$aimer.rotation = look_dir.angle()
	
	_apply_knockback()
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
	
	# recoil
	knockback += Vector2(-1,0).rotated(bul.global_rotation) * knockback_strength
	
	emit_signal("shot")
	
	muzzle_flash() #MrGeko


func jump():
	vel.y = -jump_strength
	last_jump_time = 0
	emit_signal("jumped")


func hurt(amt:float, dir:Vector2):
	if immortal:
		return 
	_set_health(health - amt)
	if health <= 0:	die()
	else:			emit_signal("health_changed")
	knockback += dir * hurt_knockback_strength
	immortal = true
	yield(get_tree().create_timer(0.2), "timeout")
	immortal = false


func die():
	if is_dead: return 
	is_dead = true
#	set_physics_process(false)
	set_process_input(false)
	set_block_signals(true)
	
	$Sprite.play("Die")
	yield($Sprite, "animation_finished")
	yield(get_tree().create_timer(0.3), "timeout")
	
	set_block_signals(false)
	emit_signal("died")
	
	var lid = lid_tscn.instance()
	lid.global_position = global_position
	get_parent().add_child(lid)
	
	queue_free()


func _apply_knockback():
	if is_dead: return 
	move_and_slide(knockback)
	knockback *= knockback_decay


func _move_player() -> void:
	var move_dir = _get_input_dir() if not is_dead else Vector2()
	vel += move_dir * acceleration
	vel.x = clamp(vel.x, -max_speed, max_speed)
	
	vel.y += gravity
	
	vel = move_and_slide(vel, Vector2(0,-1))
	
	for i in get_slide_count():
		var col: KinematicCollision2D = get_slide_collision(i)
		if col and "damage" in col.collider:
			hurt(col.collider.damage, col.normal)
	
	vel.x *= damping
	
	if not was_on_floor and is_on_floor():
		emit_signal("landed")
	was_on_floor = is_on_floor()
	
	if is_on_floor():
		last_on_floor_time = OS.get_system_time_msecs()
	
	if _can_jump():
		jump()
	
	if move_dir.dot(vel) < 0: emit_signal("direction_changed")
	if not move_dir.is_equal_approx(Vector2()): 
		_set_charge(charge + 1)
		emit_signal("moved")
	else: emit_signal("stopped")


func _set_charge(v):
	charge = clamp(v, 0, 100)
	emit_signal("charge_changed")


func _set_health(v):
	health = clamp(v, 0, max_health)
	emit_signal("health_changed")


func _can_shoot() -> bool:
	return charge >= shoot_cost and _is_shoot_just_pressed()
	

func _can_jump() -> bool:
	return _in_coyote_time() and _is_jump_just_pressed()


func _in_coyote_time() -> bool:
	return OS.get_system_time_msecs() - last_on_floor_time < coyote_time_buffer


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

func muzzle_flash(): #MrGeko
	var effect = muzzleEffect.instance()
	effect.position = $aimer/offset.global_position
	get_parent().add_child(effect)
