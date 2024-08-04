extends CanvasLayer

signal can_launch_ball

var time
var blink_speed = 500
var _show_start = false
var _show_launch_ball_message = false

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	$LaunchBallMessage.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * blink_speed
	var alpha = sin(time*delta) / 2.1 + 0.4
	if _show_start:
		$Start.modulate.a = alpha
	if _show_launch_ball_message:
		$LaunchBallMessage.modulate.a = alpha
	


func show_launch_ball_message():
	time = 0
	$LaunchBallMessage.show()
	_show_launch_ball_message = true
	

func hide_launch_ball_message():
	$LaunchBallMessage.hide()
	_show_launch_ball_message = false


func show_start():
	time = 0
	_show_start = true
	$Start.show()


func hide_start():
	_show_start = false
	$Start.hide()


func hide_score():
	$ScoreLeft.hide()
	$ScoreRight.hide()


func show_score():
	$ScoreLeft.show()
	$ScoreRight.show()


func update_score_left(score):
	$ScoreLeft.text = str(score)


func update_score_right(score):
	$ScoreRight.text = str(score)


func _on_timer_timeout():
	if _show_start:
		$LaunchBallMessage/Timer.start()
		return
	show_launch_ball_message()
	can_launch_ball.emit()
