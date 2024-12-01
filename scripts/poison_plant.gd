extends Area2D

@onready var character_manager: CharacterManager = get_node("/root/Game/CharacterManager")

@export var delay: int = 0
@export var off_length: int = 2000
@export var on_length: int = 2000
@export var damage_interval: int = 750

var switch_at: int = INF
var last_switched_at: int = -INF
var damage_at: int = -INF
var is_on = false

var _first_switch_completed = false

const frames = {
	"off": [preload("res://textures/plant_off.png")],
	"on": [preload("res://textures/plant_on_1.png"),preload("res://textures/plant_on_2.png")]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	last_switched_at = GameManager.scaled_ticks_msec
	pass # Replace with function body.

func get_switch_time():
	if _first_switch_completed == false: 
		return delay
	elif is_on: 
		return on_length
	else: 
		return off_length

func p(s):
	if get_meta("printing",false) == true:
		print(s)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var last_state = is_on
	p(get_switch_time())
	while GameManager.scaled_ticks_msec - last_switched_at > get_switch_time():
		last_switched_at += get_switch_time()
		_first_switch_completed = true
		is_on = !is_on
	if is_on != last_state:
		if is_on:
			$AudioStreamPlayer2D.play_fade_in()
		else:
			$AudioStreamPlayer2D.fade_out()
		
	#if GameManager.scaled_ticks_msec > switch_at:
		#is_on = not is_on
		#var lost_msec = GameManager.scaled_ticks_msec - switch_at
		#p(lost_msec)
		#while lost_msec > (on_length if is_on else off_length):
			#lost_msec -= (on_length if is_on else off_length)
			#is_on = not is_on
		#p(is_on)
		#
		#switch_at = GameManager.scaled_ticks_msec + (on_length if is_on else off_length)
		#if is_on:
			#$AudioStreamPlayer2D.play_fade_in()
		#else:
			#$AudioStreamPlayer2D.fade_out()
	
	if is_on:
		$SpriteAnchor.scale.y = Util.scaled_smooth_step($SpriteAnchor.scale.y,1.02,0.7,delta)
		$SpriteAnchor/Sprite.texture = frames.on[floor((GameManager.scaled_ticks_msec/100))%2]
		if GameManager.scaled_ticks_msec > damage_at:
			for body in get_overlapping_bodies():
				if (body.skin == "spirit"):
					damage_at = GameManager.scaled_ticks_msec + damage_interval
					character_manager.damage(1)
					$SpriteAnchor.scale.y = 1.2
	else:
		if last_switched_at + get_switch_time() - GameManager.scaled_ticks_msec < 500:
			$SpriteAnchor.scale.y = Util.scaled_smooth_step($SpriteAnchor.scale.y,0.8,0.9,delta)
		else:
			$SpriteAnchor.scale.y = Util.scaled_smooth_step($SpriteAnchor.scale.y,1,0.7,delta)
		$SpriteAnchor/Sprite.texture = frames.off[0]
