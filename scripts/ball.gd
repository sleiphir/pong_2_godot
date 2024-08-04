extends RigidBody2D

signal zone_hit(side)

var default_move_speed = 40
var ball_size
var launched
var launcher_pad

@export var MOVE_SPEED = default_move_speed

func reset():
	launched = false
	ball_size = $Hitbox.shape.get_rect().size
	MOVE_SPEED = default_move_speed
	$LaunchTimer.start()


func _ready():
	reset()


func _physics_process(delta):
	var x = MOVE_SPEED if linear_velocity.x > 0 else -MOVE_SPEED
	var y = MOVE_SPEED / 2 if linear_velocity.y > 0 else -MOVE_SPEED / 2
	if !launched && Input.is_action_pressed("launch_ball"):
		launch_ball()


func launch_ball():
	$LaunchTimer.stop()
	var x = MOVE_SPEED if linear_velocity.x > 0 else -MOVE_SPEED
	var y = MOVE_SPEED / 2 if linear_velocity.y > 0 else -MOVE_SPEED / 2
	launched = true
	apply_central_impulse(Vector2(x * 30, y * 30))
	print("Launched ball")


func collide(body):
	MOVE_SPEED += 2
	print("current speed:", MOVE_SPEED)
	if body.name == "ZoneLeft":
		zone_hit.emit("left")
		launcher_pad = get_parent().find_child("RightPad")
	elif body.name == "ZoneRight":
		zone_hit.emit("right")
		launcher_pad = get_parent().find_child("LeftPad")
	elif body.name.begins_with("Pad"):
		var speed = MOVE_SPEED * 10
		var x = speed if linear_velocity.x > 0 else speed * -1
		var y = speed / 2 if linear_velocity.y > 0 else (speed / 2) * -1
		apply_torque_impulse(randf_range(-1, 1))
		apply_central_impulse(Vector2(x, y))



func _on_timer_timeout():
	print("timeout")
	launch_ball()
