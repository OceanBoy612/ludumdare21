extends Node2D




func init(start: Vector2, end: Vector2):
	$Line2D.points[0] = start
	$Line2D.points[1] = end
	$AnimationPlayer.play("flash")

