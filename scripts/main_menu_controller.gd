extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BottomAnchor/HBoxContainer/Lore.visible = DataManager.save_data.has_seen_lore
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	await Fader.fade(Color(0,0,0,1),0.25)
	if DataManager.save_data.has_seen_lore:
		GameManager.change_scene("res://level_select_screen.tscn")
	else:
		GameManager.change_scene("res://intro_cutscene.tscn")


func _on_controls_pressed() -> void:
	$Controls.visible = true

func _on_close_controls_pressed() -> void:
	$Controls.visible = false
