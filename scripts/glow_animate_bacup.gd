extends Node

const amount = 4
const spread = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(1,amount):
		var instance = duplicate()
		instance.set_script(null)
		instance.name = str(i)
		instance.scale = Vector2(1,1)
		instance.modulate = Color(1,1,1,self.modulate.a/amount)
		instance.set_meta("pos",instance.position)
		instance.set_meta("offset",Vector2(0,0))
		add_child(instance)
		
	self.self_modulate = Color(1,1,1,0.5)
	pass # Replace with function body.
	
	while true:
		await get_tree().create_timer(.25).timeout
		for i in range(1,amount):
			var instance = get_node(str(i))
			instance.set_meta("offset",Vector2(randf_range(-spread,spread),randf_range(-spread,spread)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(1,amount):
		var instance = get_node(str(i))
		instance.position = instance.get_meta("pos") + Util.smooth_step(instance.position - instance.get_meta("pos"),instance.get_meta("offset"),0.9,delta)
		
