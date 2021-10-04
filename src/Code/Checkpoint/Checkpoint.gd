extends Area2D


var ignore_input = false
var active = false


func _ready():
	add_to_group("checkpoints")


func _on_Area2D_body_entered(body):
	if not active:
		activate_checkpoint()


func activate_checkpoint():
	ignore_input = true
	active = true
	get_tree().call_group("checkpoints", "deactivate_checkpoint")
	
	$Sprite.play("Turn on")
	yield($Sprite, "animation_finished")
	$Sprite.play("Idle on")
	
	ignore_input = false


func deactivate_checkpoint():
	if ignore_input: return
	
	if not active: return
	active = false
	
	$Sprite.play("Turn off")
	yield($Sprite, "animation_finished")
	$Sprite.play("Idle")

