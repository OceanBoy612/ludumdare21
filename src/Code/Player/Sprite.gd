extends AnimatedSprite


onready var player: Player = get_parent() as Player


func _ready():
	player.connect("moved", self, "_on_Player_moved")
	player.connect("stopped", self, "_on_Player_stopped")


func _on_Player_moved():
	play("Walk")
	
	handle_flipping()


func _on_Player_stopped():
	play("Idle")
	
	handle_flipping()


func handle_flipping():
	if player.look_dir.x > 0:
		flip_h = false
	else:
		flip_h = true
