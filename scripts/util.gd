extends Node

func smooth_step(start, goal, alpha: float, dt: float):
	alpha = 1 - pow(alpha, dt*60)
	return start + (goal - start) * alpha
