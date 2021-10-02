extends Node2D

# MrGeko wrote this script, direct your complaints and praise his way

export(bool) var random_flip = true

onready var sprite = $Sprite

func _ready():
	sprite.playing = true
	sprite.frame = 0
	
	if random_flip:
		sprite.flip_h = randf() < 0.5
		sprite.flip_v = randf() < 0.5

func _on_Sprite_animation_finished():
	queue_free()
