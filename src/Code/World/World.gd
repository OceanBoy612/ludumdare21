extends Node2D


func _ready():
	$GUI.set_player($Player)
	$Player.connect("shot", self, "_on_player_shot")
	$Player.connect("landed", self, "_on_player_landed")
	$Player.connect("jumped", self, "_on_player_jumped")

func _on_player_shot():
	$Camera2D.add_trauma(0.2)
	$Camera2D.add_zoom(0.6)

func _on_player_jumped():
	$Camera2D.add_trauma(0.1)

func _on_player_landed():
	$Camera2D.add_trauma(0.1)



