extends Node2D




func init(start: Vector2, end: Vector2):
	$Line2D.points[0] = start
	$Line2D.points[1] = end
	
	$Area2D/col.shape.a = start
	$Area2D/col.shape.b = end
	
	$AnimationPlayer.play("flash")



func _on_Area2D_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()
