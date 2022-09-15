extends Node2D


func _physics_process(delta):
	global_position = lerp(global_position, get_global_mouse_position(), 0.02)
