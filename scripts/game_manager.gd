extends Node

signal on_scene_changed()
signal on_pause_changed(is_paused: bool)

var scaled_ticks_msec: int
var unscaled_delta: float
var current_level_path: String
var is_paused: bool = false:
	set(value):
		Engine.time_scale = 0 if value else 1
		is_paused = value
		on_pause_changed.emit(value)

func change_scene(path: String):
	get_tree().change_scene_to_file(path)
	on_scene_changed.emit()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var _last_ticks_msec: int = 0
var _last_ticks_usec: int = 0
func _process(delta):
	var ticks_msec = Time.get_ticks_msec()
	scaled_ticks_msec += (ticks_msec - _last_ticks_msec) * Engine.time_scale
	_last_ticks_msec = ticks_msec
	
	var ticks_usec = Time.get_ticks_usec()
	unscaled_delta = (ticks_usec - _last_ticks_usec)/1e6
	_last_ticks_usec = ticks_usec
