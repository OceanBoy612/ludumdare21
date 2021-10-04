extends AnimatedSprite


onready var player: Player = get_parent() as Player


var in_air = false
var flip_sprite = true


func _ready():
	player.connect("moved", self, "_on_Player_moved")
	player.connect("stopped", self, "_on_Player_stopped")
	player.connect("jumped", self, "_on_Player_jumped")
	player.connect("landed", self, "_on_Player_landed")
	player.connect("shot", self, "_on_Player_shot")


func _process(delta):
	if flip_sprite:
		_handle_flipping()


func _on_Player_shot():
	if in_air:
		play("Air fall")
	

func _on_Player_jumped():
	in_air = true
	play("Air spin")


func _on_Player_landed():
	in_air = false


func _on_Player_moved():
	if not in_air:
		play("Walk")


func _on_Player_stopped():
	if not in_air:
		play("Idle")


func _handle_flipping():
	if player.look_dir.x > 0:
		flip_h = false
	else:
		flip_h = true
