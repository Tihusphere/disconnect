extends Node

const DATA_VERSION = 1
var save_data = {
	cleared_levels = 0,
	has_seen_lore = false,
	data_version = DATA_VERSION
}
var data_has_loaded = false
var save_queued = false

func write_save_file():
	if data_has_loaded == false:
		save_queued = true
		return
		
	var file_lb_player_info = FileAccess.open("user://save_data",FileAccess.WRITE)
	file_lb_player_info.resize(0) #erase previous contents of file
	file_lb_player_info.store_string(JSON.stringify(save_data))
	file_lb_player_info.flush()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# create file if not there
	if !FileAccess.file_exists("user://save_data"):
		FileAccess.open("user://save_data",FileAccess.WRITE).close()
		
	# read the file
	var file_lb_player_info = FileAccess.open("user://save_data",FileAccess.READ_WRITE)
	var file_json = JSON.parse_string(file_lb_player_info.get_as_text())
	
	# if data has not been set up yet or is wrong, initialize it
	if file_json == null:
		write_save_file()
	# otherwise just load what's there
	else:
		save_data = file_json
		
	data_has_loaded = true
		
	if save_queued == true:
		write_save_file()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
