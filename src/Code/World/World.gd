extends Node2D


onready var curr_player = $Player
onready var player_tscn = preload("res://Code/Player/Player.tscn")


func _ready():
	curr_player.freeze_player(1.0)
	connect_player()


func connect_player():
	$GUI.set_player(curr_player)
	get_tree().call_group("enemies", "set_player", curr_player)
	
	$Camera2D.target = curr_player.get_path()
	
	curr_player.connect("shot", self, "_on_player_shot")
	curr_player.connect("died", self, "_on_player_died")
	curr_player.connect("landed", self, "_on_player_landed")
	curr_player.connect("jumped", self, "_on_player_jumped")


func _on_player_died():
	curr_player = player_tscn.instance()
	curr_player.global_position = _get_active_checkpoint().global_position
	add_child_below_node($TileMap, curr_player)
	connect_player()


func _get_active_checkpoint() -> Node2D:
	var checkpoints = get_tree().get_nodes_in_group("checkpoints")
	for c in checkpoints:
		if c.active:
			return c
	return $SpawnPoint as Node2D


func _on_player_shot():
	$Camera2D.add_trauma(0.2)
	$Camera2D.add_zoom(0.6)


func _on_player_jumped():
	$Camera2D.add_trauma(0.1)


func _on_player_landed():
	$Camera2D.add_trauma(0.1)



