extends Camera2D

func asteroid_exploded():
	$ScreenShake.start(0.1, 15, 12, 2)

func _on_Player_laser_shoot():
	$ScreenShake.start(0.1, 15, 4, 0)

func asteroid_small_exploded():
	$ScreenShake.start(0.1, 15, 8, 1)
