extends Node2D


func _ready():
	$GUI.set_player($Player)
	$Player.connect("shot", self, "_on_player_shot")


func _on_player_shot():
	$Camera2D.add_trauma(0.4)


