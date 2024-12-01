extends GridContainer

@export var level_count: int = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1,level_count+1):
		var button = $Template.duplicate()
		button.get_node("Label").text = str(i)
		if i > DataManager.save_data.cleared_levels+1:
			var m = button.get_node("TextureRect").material.duplicate()
			m["shader_parameter/active"] = true
			button.get_node("TextureRect").material = m
			button.modulate = Color(.5,.5,.5,1)
			button.set_script(null)
		else:
			button.scene_path = "res://level_"+str(i)+".tscn"
			
		if i >= DataManager.save_data.cleared_levels+1:
			button.get_node("Glow").visible = false
			
		button.visible = true
		add_child(button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
