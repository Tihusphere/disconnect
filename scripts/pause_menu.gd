extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.on_pause_changed.connect(func _on_pause_changed(is_paused: bool):
		visible = is_paused
		$Level.text = "Level "+GameManager.current_level_id
	)

func toggle():
	GameManager.is_paused = !GameManager.is_paused

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().current_scene && get_tree().current_scene.get_node_or_null("CharacterManager"):
			call_deferred("toggle")


func _on_resume_pressed() -> void:
	if GameManager.is_paused:
		call_deferred("toggle")


func _on_exit_level_pressed() -> void:
	GameManager.change_scene("res://main_menu.tscn")
	if GameManager.is_paused:
		call_deferred("toggle")
