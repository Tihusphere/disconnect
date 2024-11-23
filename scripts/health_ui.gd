extends HBoxContainer

@onready var character_manager: CharacterManager = get_node("/root/Game/CharacterManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(1,character_manager.max_health+1):
		var heart = $Template.duplicate()
		heart.name = str(i)
		heart.visible= true
		add_child(heart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var hp = character_manager.health
	for i in range(1,character_manager.max_health+1):
		var heart = get_node(str(i))
		heart.get_node("Glow").visible = i <= character_manager.health
		heart.get_node("Fill").visible = i <= character_manager.health
		
