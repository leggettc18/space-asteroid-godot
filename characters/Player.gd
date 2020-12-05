extends KinematicBody2D

signal laser_shoot
signal player_died

var player_explosion_scene = load("res://objects/ParticlesPlayerExplosion.tscn")

const SPEED := 600

func _ready():
	var camera = get_parent().get_node("MainCamera")
	self.connect("laser_shoot", camera, "_on_Player_laser_shoot")
	
	var game = get_parent()
	self.connect("player_died", game, "_on_Player_player_died")

func _physics_process(delta):
	var velocity = Vector2()
	
	if (Input.is_action_pressed("ui_left")):
		velocity.x -= SPEED
	if (Input.is_action_pressed("ui_right")):
		velocity.x += SPEED
	
	move_and_collide(velocity * delta)

func _unhandled_key_input(event):
	if(event.is_action_pressed("shoot")):
		$LaserWeapon.shoot()
		emit_signal("laser_shoot")

func explode():
	var explosion = player_explosion_scene.instance()
	explosion.position = self.position
	get_parent().add_child(explosion)
	explosion.emitting = true
	
	emit_signal("player_died")
	
	queue_free()

func _on_Hitbox_body_entered(body):
	if (!self.is_queued_for_deletion() && body.is_in_group("asteroids")):
		explode()
