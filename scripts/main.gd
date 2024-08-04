extends Node2D

@export var ball_scene: PackedScene

var time
var score_left
var score_right
var gaming
var screen_size
var current_ball
var audio_playing
var flashing_background
var default_background_color

func _ready():
	screen_size = get_viewport_rect().size
	score_left = 0
	score_right = 0
	time = 0
	default_background_color = Vector3(0.015, 0.027, 0.176)
	gaming = false
	audio_playing = false
	flashing_background = false
	$Background.material.set_shader_parameter("new_color", default_background_color)
	$HUD.hide_score()
	$HUD.show_start()
	$HUD/Title.show()
	$PadLeft.hide()
	$PadRight.hide()
	$Abberation.hide()


func _process(delta):
	if current_ball != null:
		var distance = screen_size / 2 - current_ball.position
		distance = sqrt(pow(distance.x, 2) + pow(distance.y, 2))
		if distance < 300 && audio_playing == false:
			$Attractor/Audio.play()
			audio_playing = true
		elif audio_playing && distance > 300:
			$Attractor/Audio.stop()
			audio_playing = false
	if !gaming && Input.is_action_pressed("new_game"):
		new_game()
	if flashing_background:
		flash_background(delta)


func new_game():
	$HUD.show_score()
	$HUD.hide_start()
	$HUD/Title.hide()
	$PadLeft.show()
	$PadRight.show()
	gaming = true
	new_ball()


func new_ball():
	var ball = ball_scene.instantiate()
	print("new game started")
	var pos_x = randf_range(30, 40) if randi_range(0, 1) else randf_range(-30, -40)
	var pos_y = randf_range(30, 40) if randi_range(0, 1) else randf_range(-30, -40)
	ball.position = $Attractor.position + Vector2(pos_x, pos_y)
	ball.connect("zone_hit", on_score)
	ball.connect("body_entered", ball_collide)
	current_ball = ball
	await get_tree().create_timer(0.15).timeout
	add_child(ball)


func ball_collide(body):
	$HUD/LaunchBallMessage/Timer.start()
	$HUD.hide_launch_ball_message()
	var sound = randi_range(1, 3)
	if sound == 1:
		$Sounds/BallSound1.play()
	elif sound == 2:
		$Sounds/BallSound2.play()
	else:
		$Sounds/BallSound3.play()
	current_ball.collide(body)


func on_score(side):
	$Sounds/BallSound1.stop()
	$Sounds/BallSound2.stop()
	$Sounds/BallSound3.stop()
	$Sounds/ScoreSound.play()
	current_ball.queue_free()
	new_ball()
	if side == "left":
		score_right += 1
		$HUD.update_score_right(score_right)
	elif side == "right":
		score_left += 1
		$HUD.update_score_left(score_left)
	flashing_background = true


func flash_background(delta):
	time += delta
	var color = sin(time * 5) / 2 + 0.5
	
	$Abberation.show()
	var ampl = 0.01
	var r_disp = Vector2(1, 0)
	var g_disp = Vector2(0, 1)
	var b_disp = Vector2(-1, 0)
	
	print(r_disp * color * ampl)
	
	$Abberation.material.set_shader_parameter("r_displacement", r_disp * randf() * ampl)
	$Abberation.material.set_shader_parameter("g_displacement", g_disp * randf() * ampl)
	$Abberation.material.set_shader_parameter("b_displacement", b_disp * randf() * ampl)
	
	$Background.material.set_shader_parameter("new_color", Vector3(color * 1.0117, color * 1.0127, color  * 1.167))
	if color < 0.1:
		$Abberation.hide()
		time = 0
		flashing_background = false
		$Background.material.set_shader_parameter("new_color", default_background_color)

func _on_hud_can_launch_ball():
	current_ball.launched = false
	current_ball.get_node("LaunchTimer").start()
