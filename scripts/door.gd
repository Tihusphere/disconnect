@tool
extends Node2D
class_name Door

@export var color: Key.KEY_COLOR:
	set(value):
		
		#auto rename :D
		if Engine.is_editor_hint():
			var regex = RegEx.new()
			regex.compile("(Red|Green|Purple|Yellow)?Door(\\d*)")
			var result = regex.search(name)
			if result != null:
				name = name.substr(result.get_end(1))
				name = name.trim_suffix(result.get_string(2))
				var prefix: String = Key.KEY_COLOR.keys()[value]
				prefix = prefix[0].to_upper() + prefix.to_lower().substr(1)
				name = prefix + name
				
		color = value
		update_colors()
	
		
@onready var character_manager := get_node_or_null("/root/Game/CharacterManager") as CharacterManager

var key_is_locked_in: bool = false

var been_opened = false
var key_used: Key

func update_colors():
	var color_value := Key.color_values[color] as Color
	$Anchor/Slot.modulate = Color.from_hsv(wrapf(color_value.h+0.5,0,1),color_value.s,.1)
	$Anchor/Flash.modulate = color_value
	$Anchor/Key.modulate = color_value
	$Anchor/Crystals.modulate = color_value

func lock_in_key():
	key_is_locked_in = true

func open(key: Key):
	if been_opened: return
	been_opened = true
	key_used = key	
	key.in_door = self
	key.get_node("Sprite/RingSound").play()
	key.get_node("AnimationPlayer").play("go_to_door")
	$AnimationPlayer.play("open")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_colors()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if key_is_locked_in == true && key_used:
		key_used.get_node("Sprite").global_position = $Anchor/Key.global_position


func _on_trigger_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter && body.skin == "spirit":
		if character_manager.current_key != null && character_manager.current_key.color == color:
			open(character_manager.current_key)
