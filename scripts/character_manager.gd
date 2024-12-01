extends Node
class_name CharacterManager

@export var this_level: String = "1"

@onready var spirit := get_node_or_null("/root/Game/Spirit") as PlayerCharacter
@onready var body := get_node_or_null("/root/Game/Body") as PlayerCharacter

@onready var is_game = true if get_node_or_null("/root/Game") else false
const frames_of_delay: int = 90

class FrameInput:
	var direction: int = 0
	var did_jump: bool = false
	var knockbacks: Array[Vector2] = []
	var known_position: Vector2
	
var current_key: Key = null
var max_health: int = 4
var health: int = max_health
var input_history: Array[FrameInput] = []

var invul_until: int = -INF
var jump_buffered_until: int = -INF
	
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.current_level_path = get_tree().current_scene.scene_file_path

func damage(amount: int):
	if health <= 0: return
	if (GameManager.scaled_ticks_msec > invul_until):
		invul_until = GameManager.scaled_ticks_msec + 500
		health -= amount
		spirit.modulate = Color(255,1,1,1)
		MusicManager.play_dmg()
		if (health <= 0):
			spirit.playing_death_animation = true
			await Util.wait(1)
			await Fader.fade(Color(0,0,0,1),0.25)
			GameManager.change_scene(GameManager.current_level_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_game:
		spirit = get_node_or_null("/root/Game/Spirit")
		body = get_node_or_null("/root/Game/Body")
	else:
		return
	
	if GameManager.is_paused: return
	
	var history_entry = FrameInput.new()
	
	# pass input to spirit
	spirit.direction = Input.get_axis("left", "right")
	history_entry.direction = spirit.direction
	if Input.is_action_just_pressed("jump"):
		if (Time.get_ticks_msec() < spirit.coyote_time_ends_at) || spirit.is_grounded():
			history_entry.did_jump = true
			spirit.jump()
		else:
			jump_buffered_until = Time.get_ticks_msec() + 75
	elif Time.get_ticks_msec() < jump_buffered_until:
		if spirit.is_on_floor():
			history_entry.did_jump = true
			spirit.jump()
			
	if Input.is_action_just_pressed("reset"):
		await Fader.fade(Color(0,0,0,1),0.25)
		GameManager.change_scene(GameManager.current_level_path)
		
	if (spirit.get_node("PlayerDetector")as Area2D).overlaps_area(body.get_node("PlayerDetector")):
		if (GameManager.scaled_ticks_msec > invul_until):
			var kb = Vector2(sign((spirit.global_position - body.global_position).x) * 400,-500)
			spirit.knockback(kb)
			history_entry.knockbacks.append(kb)
			damage(1)
			
	history_entry.known_position = spirit.global_position
		
	# input playback
	input_history.append(history_entry)
	if (input_history.size() > frames_of_delay):
		body.allow_color_resolve = true
		
		var frame = input_history[0]
		
		body.global_position = frame.known_position
		
		#walk
		body.direction = frame.direction
		
		#jump
		if (frame.did_jump):
			body.jump()
		
		#knokback
		for kb in frame.knockbacks:
			body.knockback(kb)
			
		input_history.pop_at(0)
