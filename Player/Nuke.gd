extends Area2D

var velocity = Vector2(0, -10)
var damage = 20
var Explosion = load("res://Effects/explosion.tscn")
var blast_radius = []



func _ready():
	velocity = velocity.rotated(rotation)
	
func _physics_process(_delta):
	position += velocity
		

func _on_body_entered(body):
	if body.name != "Player":
		for b in blast_radius:
			if b.has_method("damage"):
				b.damage(damage)
		var Effects = get_node("/root/Game/Effects")
		var explosion = Explosion.instantiate()
		explosion.global_position = global_position
		explosion.scale = Vector2(50.0,50.0)
		Effects.add_child(explosion)
		queue_free()
	


func _on_blast_body_entered(body):
	if body.name != "Player":
		if body not in blast_radius:
			blast_radius.append(body)


func _on_blast_body_exited(body):
	for b in range(blast_radius.size()):
		if body == blast_radius[b]:
			blast_radius.remove_at(b)
			break
			


func _on_nuke_blast_body_entered(body):
	if body.name != "Player":
		if body not in blast_radius:
			blast_radius.append(body)
	


func _on_nuke_blast_body_exited(body):
	for b in range(blast_radius.size()):
		if body == blast_radius[b]:
			blast_radius.remove_at(b)
			break
	
