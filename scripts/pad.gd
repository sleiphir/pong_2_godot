extends StaticBody2D

enum PAD_TYPE { PLAYER_1, PLAYER_2, AI }
 
@export var MOVE_SPEED = 600
@export var TYPE = PAD_TYPE.AI
@export var SIDE = ""

var screen_size
var pad_size
var action_move_up
var action_move_down
var ball

func _ready():
	pad_size = Vector2.ZERO
	screen_size = get_viewport_rect().size
	pad_size = $Hitbox.shape.get_rect().size
	# Add player specific actions
	if TYPE != PAD_TYPE.AI:
		var action_prefix = PAD_TYPE.keys()[TYPE].to_lower()
		action_move_up = action_prefix + "_move_up"
		action_move_down = action_prefix + "_move_down"


func _process(delta):
	var velocity_y = 0
	if TYPE == PAD_TYPE.AI:
		velocity_y = ai_move()
	else:
		velocity_y = Input.get_action_strength(action_move_up) - Input.get_action_strength(action_move_down)
	position.y = clamp(position.y - velocity_y  * MOVE_SPEED * delta, pad_size.y, screen_size.y - (pad_size.y))


func ai_move():
	if ball == null:
		ball = get_parent().get_tree().get_first_node_in_group("ball")
		return 0
	var gap_x = 0
	var ball_direction = ball.linear_velocity.normalized()
	if SIDE == "left":
		return 1 if position.y > (ball.position.y) else -1
		if ball.linear_velocity.x > 0:
			return 1 if position.y > (screen_size.y / 2) else -1
		gap_x = ball.position.x - position.x
	elif SIDE == "right":
		if ball.linear_velocity.x < 0:
			return 1 if position.y > (screen_size.y / 2) else -1
		gap_x = (position.x - pad_size.x / 2 - ball.ball_size.x / 2) - ball.position.x
	var mul = gap_x / ball_direction.x
	var predicted = ball.position + ball_direction * mul
	if predicted.y > 0 && predicted.y < screen_size.y:
		return 1 if position.y > predicted.y else -1
	return 1 if position.y > (ball.position.y) else -1
