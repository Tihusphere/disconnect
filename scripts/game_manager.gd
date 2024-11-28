extends Node

signal on_scene_changed()

var current_level: String

func change_scene(path: String):
	get_tree().change_scene_to_file(path)
	on_scene_changed.emit()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
