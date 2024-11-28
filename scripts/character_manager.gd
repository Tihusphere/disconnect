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
var resync_position_at: int = 5000
	
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.current_level = this_level

func damage(amount: int):
	if (Time.get_ticks_msec() > invul_until):
		invul_until = Time.get_ticks_msec() + 500
		health -= amount
		spirit.modulate = Color(255,1,1,1)
		MusicManager.play_dmg()
		if (health <= 0):
			GameManager.change_scene("res://death_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_game:
		spirit = get_node_or_null("/root/Game/Spirit")
		body = get_node_or_null("/root/Game/Body")
	else:
		return
	
	var history_entry = FrameInput.new()
	
	# pass input to spirit
	spirit.direction = Input.get_axis("left", "right")
	history_entry.direction = spirit.direction
	if Input.is_action_just_pressed("jump") and ((Time.get_ticks_msec() < spirit.coyote_time_ends_at) || (spirit.double_jumps_remaining > 0)):
		history_entry.did_jump = true
		spirit.jump()
		
	if (spirit.get_node("PlayerDetector")as Area2D).overlaps_area(body.get_node("PlayerDetector")):
		if (Time.get_ticks_msec() > invul_until):
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
		
		if true:
			resync_position_at = Time.get_ticks_msec() + 500
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
