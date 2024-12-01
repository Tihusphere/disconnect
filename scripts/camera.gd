extends Camera2D

@export var follow: Node2D
var first_frame_passed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position.x = follow.global_position.x
	limit_smoothed = true
	position_smoothing_speed = 10
	(func _enable_smoothing():
		position_smoothing_enabled = true
	).call_deferred()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x = follow.global_position.x
