extends CanvasLayer

var speed = 0.05
var slide = 1
var debounce = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	if debounce: return
	debounce = true
	
	var old_slide = get_node(str(slide))
	while old_slide.modulate.a > speed:
		old_slide.modulate.a -= speed
		await get_tree().create_timer(.01).timeout
	old_slide.visible = false
		
	slide += 1
	var new_slide = get_node_or_null(str(slide))
	
	if new_slide == null:
		DataManager.save_data.has_seen_lore = true
		DataManager.write_save_file()
		GameManager.change_scene("res://level_select_screen.tscn")
		return
	
	new_slide.modulate.a = 0
	new_slide.visible = true
	
	
	while new_slide.modulate.a < 1:
		new_slide.modulate.a += speed
		await get_tree().create_timer(.01).timeout

	debounce = false
