extends CanvasLayer


var player: Player
onready var tween: Tween = $Gauges/Tween


func set_player(p: Player):
	player = p
	
	player.connect("charge_changed", self, "_on_player_charge_changed")
	player.connect("health_changed", self, "_on_player_health_changed")
	
	_on_player_health_changed()
	_on_player_charge_changed()


func _on_player_charge_changed():
	$Gauges/Power.max_value = 100
	
	tween.interpolate_property($Gauges/Power, "value", $Gauges/Power.value, player.charge, 
			0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
#	$Gauges/Power.value = player.charge


func _on_player_health_changed():
	$Gauges/Health.max_value = player.max_health
	tween.interpolate_property($Gauges/Health, "value", $Gauges/Health.value, player.health, 
			0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	
