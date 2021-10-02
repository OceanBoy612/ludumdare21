extends CanvasLayer


var player: Player


func set_player(p: Player):
	player = p
	
	player.connect("shot", self, "_on_player_shot")
	player.connect("moved", self, "_on_player_moved")


func _on_player_moved():
	$ProgressBar.value = player.charge


func _on_player_shot():
	$ProgressBar.value = player.charge
