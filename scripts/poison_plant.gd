extends Area2D

@onready var character_manager: CharacterManager = get_node("/root/Game/CharacterManager")

@export var delay: int = 0
@export var off_length: int = 2000
@export var on_length: int = 2000
@export var damage_interval: int = 750

@onready var switch_at: int = Time.get_ticks_msec() + delay
var damage_at: int = -INF
var is_on = false

const frames = {
	"off": [preload("res://textures/plant_off.png")],
	"on": [preload("res://textures/plant_on_1.png"),preload("res://textures/plant_on_2.png")]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Time.get_ticks_msec() > switch_at:
		is_on = not is_on
		switch_at = Time.get_ticks_msec() + (on_length if is_on else off_length)
		if is_on:
			$AudioStreamPlayer2D.play_fade_in()
		else:
			$AudioStreamPlayer2D.fade_out()
	
	if is_on:
		$Sprite.texture = frames.on[floor((Time.get_ticks_msec()/100))%2]
		if Time.get_ticks_msec() > damage_at:
			for body in get_overlapping_bodies():
				if (body.skin == "spirit"):
					damage_at = Time.get_ticks_msec() + damage_interval
					character_manager.damage(1)
	else:
		$Sprite.texture = frames.off[0]
