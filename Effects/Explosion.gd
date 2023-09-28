extends AnimatedSprite2D



func _ready():
	play("default")
	var Explosion_Sound = get_node_or_null("/root/Game/Explosion_Sound")
	if Explosion_Sound != null:
		Explosion_Sound.play()
		



func _on_animation_finished():
	queue_free()
	
