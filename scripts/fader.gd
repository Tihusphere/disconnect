extends CanvasLayer

var started_at_msec: int = -INF
var length_msec: int = 0
@onready var start_color: Color = $ColorRect.color
var goal_color: Color
var idle_color: Color = Color(0,0,0,0)

func fade(color: Color, time_sec: float, from_color = null, color_when_finished = null):
	if color_when_finished: idle_color = color_when_finished
	if from_color != null:
		start_color = from_color
		$ColorRect.color = start_color
	else:
		start_color = $ColorRect.color
	
	started_at_msec = GameManager.scaled_ticks_msec
	length_msec = time_sec * 1000
	
	goal_color = color
	
	
	await Util.wait(time_sec + .01)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t = remap(GameManager.scaled_ticks_msec - started_at_msec,0,length_msec,0,1)
	if t < 1 and t >= 0:
		$ColorRect.color = start_color.lerp(goal_color,t)
		#$ColorRect.color.a = lerpf($ColorRect.color.a,goal_color.a,t)
		
		# if all that yapping spits out an invalid color, set to transparent
		if is_nan($ColorRect.color.r): $ColorRect.color = Color(0,0,0,0)
	elif t < 0:
		$ColorRect.color = start_color
	else:
		if goal_color.a == 0:
			$ColorRect.color = idle_color
		else:
			$ColorRect.color = goal_color
