extends HBoxContainer

@onready var character_manager: CharacterManager = get_node("/root/Game/CharacterManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(1,character_manager.max_health+1):
		var heart = $Template.duplicate(true)
		(heart.get_node("Fill") as TextureRect).material = (heart.get_node("Fill") as TextureRect).material.duplicate(true)
		(heart.get_node("Fill") as TextureRect).material["shader_parameter/noise"].noise.seed = randi()
		
		heart.name = str(i)
		heart.visible= true
		add_child(heart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var hp = character_manager.health
	for i in range(1,character_manager.max_health+1):
		var heart = get_node(str(i))
		var new_state = i <= character_manager.health
		var previous_state = heart.get_meta("previous_state")
		if previous_state != new_state:
			heart.get_node("AnimationPlayer").play("unbreak" if new_state else "break")
			heart.set_meta("previous_state",new_state)
		#heart.get_node("Glow").visible = previous
		#heart.get_node("Fill").visible = i <= character_manager.health
		
