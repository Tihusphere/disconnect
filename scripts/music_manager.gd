extends AudioStreamPlayer

func play_dmg():
	$Damage.play(.23)

# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass