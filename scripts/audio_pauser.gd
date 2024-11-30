extends Node
class_name AudioPauser

@onready var parent: Node = get_parent()
var saved_position: float = -1

func _ready():
	assert(parent is AudioStreamPlayer || parent is AudioStreamPlayer2D || parent is AudioStreamPlayer3D,"AudioPauser must be parented to an audio stream player (node path:"+str(get_path())+")")
	
	GameManager.on_pause_changed.connect(func _on_pause_changed(is_paused: bool):
		if is_paused:
			if parent.playing:
				saved_position = parent.get_playback_position()
				parent.stop()
			else:
				saved_position = -1
		else:
			if saved_position > -1:
				parent.play()
				parent.seek(saved_position)
	)
