extends Node2D

var is_game_over := false
var player_scene := load("res://characters/Player.tscn")

func _ready():
	connect("resized", self, "call_wrap_around")

func call_wrap_around():
	get_tree().call_group("wrap_around", "recalculate_wrap_area")

# Game Over
func _on_Player_player_died():
	# stop music and load game over jingle
	$MusicPlayer.stop()
	$MusicPlayer.stream = load("res://assets/audio/music/sawsquarenoise_-_06_-_Towel_Defence_Jingle_Loose.ogg")
	$MusicPlayer.stream.loop = false
	$MusicPlayer.volume_db = -5
	
	# stop spawning asteroids
	$AsteroidSpawner/SpawnTimer.stop()
	
	# turn off all the asteroids's sounds
	for a in get_tree().get_nodes_in_group("asteroids"):
		if (!a.is_queued_for_deletion() and a.has_node("AudioStreamPlayer2D")):
			a.get_node("AudioStreamPlayer2D").stop()
	
	$GameOverTimer.start()


func _on_GameOverTimer_timeout():
	$MusicPlayer.play(0)
	$GameOverLabel.visible = true
	is_game_over = true


func _unhandled_input(event):
	if(is_game_over and event.is_action_pressed("restart_game")):
		_restart_game()

func _restart_game():
	_undo_game_over()
	_respawn_player()
	$AsteroidSpawner.restart()
	$GUI/MarginContainer/HBoxContainer/VBoxContainer/Score.reset()
	is_game_over = false

func _undo_game_over():
	$GameOverLabel.visible = false
	$MusicPlayer.stop()
	$MusicPlayer.stream = load("res://assets/audio/music/sawsquarenoise_-_03_-_Towel_Defence_Ingame.ogg")
	$MusicPlayer.stream.loop = false
	$MusicPlayer.volume_db = -10
	$MusicPlayer.play(0)

func _respawn_player():
	var player = player_scene.instance()
	player.position = Vector2(640, 650)
	add_child(player)
