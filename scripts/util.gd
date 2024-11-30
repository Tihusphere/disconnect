extends Node

static func smooth_step(start, goal, alpha: float, dt: float):
	alpha = 1 - pow(alpha, dt*60)
	return start + (goal - start) * alpha

func wait(time_seconds: float):
	var tree = get_tree()
	if tree == null: return
	await get_tree().create_timer(time_seconds).timeout
