extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(func _body_entered(body):
		if (body.get_meta("is_char")):
			print(body)
			get_node("/root/Game/CharacterManager").damage(9999)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
