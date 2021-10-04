extends StaticBody2D


var is_switched = false


func _ready():
	$Sprite.play("Idle")


func hurt():
	if is_switched: return
	is_switched = true
	
	$Sprite.play("Die")
	yield($Sprite, "animation_finished")
	$Sprite.play("Dead")
	
	for i in range(2, get_child_count()):
		get_child(i).queue_free()
		print(i)
		
