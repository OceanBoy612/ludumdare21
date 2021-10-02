extends CanvasLayer


var player: Player


func set_player(p: Player):
	player = p
	
	player.connect("charge_changed", self, "_on_player_charge_changed")
	player.connect("health_changed", self, "_on_player_health_changed")
	
	_on_player_health_changed()
	_on_player_charge_changed()


func _on_player_charge_changed():
	$Gauges/Power.max_value = 100
	$Gauges/Power.value = player.charge


func _on_player_health_changed():
	$Gauges/Health.max_value = player.max_health
	$Gauges/Health.value = player.health
	
