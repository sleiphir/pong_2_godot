extends Area2D

var screen_size
var size
var time

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	screen_size = get_viewport_rect().size
	size = $Shader.get_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	position.x = size.x * (cos(time) / 2 + 0.5) + (screen_size.x / 2 - size.x / 2) 
	position.y = size.y * (sin(time) / 2 + 0.5) + (screen_size.y / 2 - size.y / 2)
