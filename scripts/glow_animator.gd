extends Node
class_name GlowAnimator

@export var amount: int = 5
@export var spread: float = 100

@onready var target: Node = get_parent()
var instances: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var template = target.duplicate()
	for c in template.get_children(): c.free()
	
	for i in range(1,amount):
		var instance = template.duplicate()
		instance.name = "glow_"+str(i)
		instance.scale = Vector2(1,1)
		instance.modulate = Color(1,1,1,target.modulate.a/2/amount)
		target.add_child.call_deferred(instance)
		instances.append(instance)
	
	target.self_modulate = Color(1,1,1,target.modulate.a/2)
	target.modulate.a = 1
	
	while true:
		for instance in instances:
			instance.set_meta("goal_offset",Vector2(randf_range(-spread,spread),randf_range(-spread,spread)))
		await Util.wait(0.125)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for instance in instances:
		instance.position = Util.smooth_step(instance.position,instance.get_meta("goal_offset"),0.98,delta)
