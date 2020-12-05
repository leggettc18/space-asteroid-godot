extends Node

var asteroid_scene = load("res://objects/Asteroid.tscn")
var asteroid_spawn_interval := 2.0
var difficulty_index := 1.5

func _ready():
	_spawn_asteroid()
	
func _spawn_asteroid():
	var asteroid = asteroid_scene.instance()
	_set_asteroid_position(asteroid)
	_set_asteroid_trajectory(asteroid)
	add_child(asteroid)

func _set_asteroid_position(asteroid):
	var rect = get_viewport().size
	asteroid.position = Vector2(rand_range(0, rect.x), -100)

func _set_asteroid_trajectory(asteroid):
	asteroid.angular_velocity = rand_range(-4, 4)
	asteroid.angular_damp = 0
	asteroid.linear_velocity = Vector2(rand_range(-300, 300), 300)
	asteroid.linear_damp = 0

func restart():
	$SpawnTimer.stop()
	$DifficultyTimer.stop()
	asteroid_spawn_interval = 2.0
	difficulty_index = 1.5
	$SpawnTimer.start()
	$DifficultyTimer.start()

func _on_SpawnTimer_timeout():
	_spawn_asteroid()


func _on_DifficultyTimer_timeout():
	$SpawnTimer.wait_time = float(asteroid_spawn_interval) / float(difficulty_index)
	difficulty_index += 1
	print($SpawnTimer.wait_time)
