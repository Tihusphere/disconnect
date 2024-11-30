extends Area2D

@export var scene_path: String
@onready var character_manager := get_node_or_null("/root/Game/CharacterManager") as CharacterManager


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	character_manager.invul_until = INF
	await Fader.fade(Color(0,0,0,1),0.25)
	GameManager.change_scene(scene_path)
