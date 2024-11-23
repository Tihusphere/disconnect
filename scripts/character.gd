extends CharacterBody2D

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

var double_jumps_remaining: int = 1
var knockback_until: int = -INF
var knockback_vector: Vector2 = Vector2(0,0)
var coyote_time_ends_at: int = -INF
var allow_color_resolve = true

# input
var direction: int = 0
func jump():
	$SpriteAnchor.scale.y = 0.7
	$SpriteAnchor.scale.x = 1.2
	velocity.y = JUMP_VELOCITY
	if (!is_grounded()):
		double_jumps_remaining -= 1
		
func is_grounded():
	return is_on_floor() or $GroundBonus.get_overlapping_bodies()

func knockback(vec: Vector2):
	knockback_vector = vec
	knockback_until = Time.get_ticks_msec() + 150

func update_frame():
	if direction == 0:
		$SpriteAnchor/Sprite.texture = frames[skin].idle[0]
	else:
		$SpriteAnchor/Sprite.flip_h = direction == 1
		$SpriteAnchor/Sprite.texture = frames[skin].walk[floor((Time.get_ticks_msec()/250))%2]
			
	
			
func _ready():
	if skin == "spirit":
		var m = CanvasItemMaterial.new()
		m.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		$SpriteAnchor/Sprite.material = m
	else:
		modulate = Color(1,1,1,0)
		allow_color_resolve = false

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
	if is_grounded():
		double_jumps_remaining = 0
		coyote_time_ends_at = Time.get_ticks_msec() + 200
	else:
		velocity += get_gravity() * delta
		
	$SpriteAnchor.scale.y = Util.smooth_step($SpriteAnchor.scale.y,1,0.9,delta)
	$SpriteAnchor.scale.x = Util.smooth_step($SpriteAnchor.scale.x,1,0.9,delta)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x += SPEED * direction * ACCELERATION
	velocity.x *= DRAG
	
	if (Time.get_ticks_msec() < knockback_until):
		velocity = knockback_vector

	move_and_slide()
