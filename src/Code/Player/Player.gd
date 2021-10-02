extends KinematicBody2D
class_name Player


signal moved
signal stopped
signal direction_changed


export(float, 0, 1000, 10) var acceleration: float = 300.0
export(float, 0, 1, 0.025) var damping: float = 0.80
export(float, 0, 1000, 10) var max_speed: float = 400.0
export(float, 0, 200, 10) var gravity: float = 50.0


var move_dir: Vector2 = Vector2()
var look_dir: Vector2 = Vector2()
var vel: Vector2 = Vector2()


func _physics_process(delta):
	look_dir = _get_dir_to_mouse()
	
	_move_player()



func _move_player() -> void:
	var move_dir = _get_input_dir()
	vel += move_dir * acceleration
	vel.x = clamp(vel.x, -max_speed, max_speed)
	
	vel += Vector2(0, gravity) # gravity
	
	vel = move_and_slide(vel, Vector2(0,-1))
	vel *= damping
	
	if move_dir.dot(vel) < 0: emit_signal("direction_changed")
	if not move_dir.is_equal_approx(Vector2()): emit_signal("moved")
	else: emit_signal("stopped")


func _get_input_dir() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

func _get_dir_to_mouse() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()
