@tool

extends Node2D
class_name Key

enum KEY_COLOR {
	RED,
	YELLOW,
	GREEN,
	PURPLE
}

static var color_values = {
	KEY_COLOR.RED: Color("#ff6969"),
	KEY_COLOR.YELLOW: Color("#ffe669"),
	KEY_COLOR.GREEN: Color("#69ff69"),
	KEY_COLOR.PURPLE: Color("#cd87ff"),
}

@export var color: KEY_COLOR:
	set(value):
		modulate = color_values[value]
		
		#auto rename :D
		if Engine.is_editor_hint():
			var regex = RegEx.new()
			regex.compile("(Red|Green|Purple|Yellow)?Key(\\d*)")
			var result = regex.search(name)
			if result != null:
				name = name.substr(result.get_end(1))
				name = name.trim_suffix(result.get_string(2))
				var prefix: String = KEY_COLOR.keys()[value]
				prefix = prefix[0].to_upper() + prefix.to_lower().substr(1)
				name = prefix + name
				
		color = value
		
@onready var character_manager := get_node_or_null("/root/Game/CharacterManager") as CharacterManager

var is_picked_up: bool = false
var in_door: Door

var last_rotation_offset: float = 0.0

func pick_up():
	if is_picked_up || in_door: return
	
	if character_manager.current_key != null:
		character_manager.current_key.put_down()
	
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("pickup")
	$PickupSound.play()
	
	character_manager.current_key = self
	is_picked_up = true
	
		
func put_down():
	if character_manager.current_key == self:
		character_manager.current_key = null
	is_picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = color_values[color]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if GameManager.is_paused: return
	
	# sprite positioning
	var sprite_goal_pos = global_position
	var sprite_pos_easing = 0.9
	if in_door != null:
		sprite_goal_pos = in_door.get_node("Anchor/Key").global_position
		if in_door.key_is_locked_in: 
			visible = false
			return
		sprite_pos_easing = 0.87
	elif is_picked_up:
		sprite_goal_pos = character_manager.spirit.global_position + Vector2(-character_manager.spirit.visual_direction*40,-80)
		
	var original_position = $Sprite.global_position
	$Sprite.global_position = Util.scaled_smooth_step($Sprite.global_position,sprite_goal_pos,sprite_pos_easing,delta)
	
	
	# sprite rotationing
	$Sprite.global_rotation -= last_rotation_offset
	if in_door:
		$Sprite.global_rotation = Util.scaled_smooth_step($Sprite.global_rotation,in_door.get_node("Anchor/Key").global_rotation,sprite_pos_easing,delta)
		
	last_rotation_offset = ($Sprite.global_position.x - original_position.x) * delta
	$Sprite.global_rotation += last_rotation_offset
	
	# sprite floating animation
	if in_door == null:
		$Sprite.offset.y = sin(GameManager.scaled_ticks_msec/500.0)*40
	else:
		$Sprite.offset.y = Util.scaled_smooth_step($Sprite.offset.y,0,0.9,delta)

func _on_pickup_trigger_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter && body.skin == "spirit":
		pick_up()
