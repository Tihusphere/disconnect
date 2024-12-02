extends AudioStreamPlayer

@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var music_low_pass: AudioEffectLowPassFilter = AudioServer.get_bus_effect(music_bus_index,0)

var cutoff_goal = 10000.0
var easing = 0.8
var music_on = true

func play_dmg():
	$Damage.play(.23)

# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	GameManager.on_pause_changed.connect(func _on_pause_changed(is_paused):
		if is_paused:
			music_low_pass.cutoff_hz = 4000
			cutoff_goal = 300.0
			easing = 0.8
		else:
			cutoff_goal = 10000.0
			easing = 0.96
	)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("toggle_music"):
		music_on = !music_on
	music_low_pass.cutoff_hz = Util.smooth_step(music_low_pass.cutoff_hz,cutoff_goal,easing,GameManager.unscaled_delta)
	volume_db = Util.smooth_step(volume_db,0 if music_on else -80,0.9 if music_on else 0.98,GameManager.unscaled_delta)
