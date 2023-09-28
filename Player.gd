extends CharacterBody2D

var speed = 5
var rotate_speed = 0.08
var max_speed = 400
var nose = Vector2(0,-60)
var health = 10
var Bullet = load("res://Player/bullet.tscn")
var Bomb = load("res://Player/bomb.tscn")
var Nuke = load("res://Player/nuke.tscn")
var Bullet_Sound = null
var Bomb_Sound = null
var Nuke_Sound

var Effects = null
var Explosion = load("res://Effects/explosion.tscn")

func get_input():
	var to_return = Vector2.ZERO
	$Exhaust.hide()
	if Input.is_action_pressed("Forward"):
		to_return += Vector2(0,-1)
		$Exhaust.show()
	if Input.is_action_pressed("Left"):
		rotation -= rotate_speed
	if Input.is_action_pressed("Right"):
		rotation += rotate_speed
	return to_return.rotated(rotation)
	

func _physics_process(_delta):
	velocity += get_input()*speed
	velocity = velocity.normalized() * clamp(velocity.length(), 0, max_speed)
	
	position.x = wrapf(position.x, 0, Global.VP.x)
	position.y = wrapf(position.y, 0, Global.VP.y)
	
	velocity = velocity.normalized() * clamp(velocity.length(), 0, max_speed)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("Shoot"):
		if Global.ammo_bullet > 0:
			Global.update_ammo_bullet(-1)
			var bullet = Bullet.instantiate()
			bullet.position = position + nose.rotated(rotation)
			bullet.rotation = rotation
			var Effects = get_node_or_null("/root/Game/Effects")
			if Effects != null:
				Bullet_Sound = get_node_or_null("/root/Game/Bullet_Sound")
				if Bullet_Sound != null:
					Bullet_Sound.play()
				Effects.add_child(bullet)
			
			
	if Input.is_action_just_pressed("Bomb"):
		if Global.ammo_bomb > 0:
			Global.update_ammo_bomb(-1)
			
			print(Global.ammo_bomb)
			var bomb = Bomb.instantiate()
			bomb.position = position + nose.rotated(rotation)
			bomb.rotation = rotation
			var Effects = get_node_or_null("/root/Game/Effects")
			if Effects != null:
				Global.update_ammo_bomb(-1)
				Bomb_Sound = get_node_or_null("/root/Game/Explosion_Sound")
				if Bomb_Sound != null:
					Bomb_Sound.play()
				Effects.add_child(bomb)
			
	if Input.is_action_just_pressed("Nuke"):
		if Global.ammo_nuke > 0:
			Global.update_ammo_nuke(-1)
			var nuke = Nuke.instantiate()
			nuke.position = position + nose.rotated(rotation)
			nuke.rotation = rotation
			var Effects = get_node_or_null("/root/Game/Effects")
			if Effects != null:
				Nuke_Sound = get_node_or_null("/root/Game/Explosion_Sound")
				if Nuke_Sound != null:
					for i in range(1000):
						Nuke_Sound.play()
				Effects.add_child(nuke)		
			
func damage(d):
	health -= d
	if health <= 0:
		Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null:
		var explosion = Explosion.instantiate()
		Effects.add_child(explosion)
		explosion.global_position = global_position
		hide()
		await explosion.animation_finished
	Global.update_lives(-1)
	queue_free()

	

func _on_area_2d_body_entered(body):
	if body.name != "Player":
		damage(100)
