extends Button

@export var scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(func _pressed():
		GameManager.change_scene(scene_path)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
