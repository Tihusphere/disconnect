extends CharacterBody2D
class_name PlayerCharacter

@export var skin = "body"

const frames = {
	"body": {
		"idle": [preload("res://textures/body_idle.png")],
		"walk": [preload("res://textures/body_walk_1.png"),preload("res://textures/body_walk_2.png")]
	},
	"spirit": {
		"idle": [preload("res://textures/spirit_idle.png")],
		"walk": [preload("res://textures/spirit_walk_1.png"),preload("res://textures/spirit_walk_2.png")]
	},
}

const SPEED = 50.0
const JUMP_VELOCITY = -700.0
const DRAG = 0.9
const ACCELERATION = 0.7

var knockback_until: int = -INF
var knockback_vector: Vector2 = Vector2(0,0)
var coyote_time_ends_at: int = -INF
var allow_color_resolve = true
var jumped_this_frame = false
var playing_death_animation = false

var visual_direction: int = -1

# input
var direction: int = 0
func jump():
	$SpriteAnchor.scale.y = 0.7
	$SpriteAnchor.scale.x = 1.2
	velocity.y = JUMP_VELOCITY
	$JumpSound.play()
	coyote_time_ends_at = -INF
	jumped_this_frame = true
		
func is_grounded():
	return is_on_floor() or $GroundBonus.get_overlapping_bodies()

func knockback(vec: Vector2):
	knockback_vector = vec
	knockback_until = GameManager.scaled_ticks_msec + 150

func update_frame():
	if playing_death_animation: return
	if direction == 0:
		$SpriteAnchor/Sprite.texture = frames[skin].idle[0]
	else:
		$SpriteAnchor/Sprite.flip_h = direction == 1
		$SpriteAnchor/Sprite.texture = frames[skin].walk[floor((GameManager.scaled_ticks_msec/250))%2]
		visual_direction = direction
			
	
			
func _ready():
	if skin == "spirit":
		var m = preload("res://shaders/death_effect.tres").duplicate(true)
		$SpriteAnchor.material = m
	else:
		modulate = Color(1,1,1,0)
		allow_color_resolve = false
		
func _process(delta):
	if skin == "spirit" && playing_death_animation:
		$SpriteAnchor.material["shader_parameter/progress"] = clampf($SpriteAnchor.material["shader_parameter/progress"]+(delta/1.5),0,1)
		$SpriteAnchor/Sprite.scale += Vector2(delta,delta)
		$SpriteAnchor.z_index = 2
		
func _physics_process(delta):
	update_frame()
	
	#end damage flash
	if allow_color_resolve:
		modulate = Color(
			Util.smooth_step(modulate.r,1,0.9,delta),
			Util.smooth_step(modulate.g,1,0.9,delta),
			Util.smooth_step(modulate.b,1,0.9,delta),
			Util.smooth_step(modulate.a,1,0.9,delta),
		)
		
	# Add the gravity.
	if is_grounded() && !jumped_this_frame:
		coyote_time_ends_at = GameManager.scaled_ticks_msec + 1000
	if !is_on_floor():
		velocity += get_gravity() * delta
		
	$SpriteAnchor.scale.y = Util.smooth_step($SpriteAnchor.scale.y,1,0.9,delta)
	$SpriteAnchor.scale.x = Util.smooth_step($SpriteAnchor.scale.x,1,0.9,delta)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x += SPEED * direction * ACCELERATION
	velocity.x *= DRAG
	
	if (GameManager.scaled_ticks_msec < knockback_until):
		velocity = knockback_vector

	if playing_death_animation:
		velocity = Vector2(0,0)

	move_and_slide()
