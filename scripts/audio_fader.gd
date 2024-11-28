extends AudioStreamPlayer2D

var original_volume = volume_db
@onready var goal_volume = volume_db

var current_easing: float = 0.97

func fade_out(easing: float = 0.97):
	current_easing = easing
	goal_volume = -80
	await get_tree().create_timer(.5).timeout
	stop()

func play_fade_in(easing: float = 0.97):
	current_easing = easing
	play()
	goal_volume = original_volume
	volume_db = original_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	volume_db = Util.smooth_step(volume_db,goal_volume,current_easing,delta)
