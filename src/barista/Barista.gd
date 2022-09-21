extends KinematicBody2D

onready var nav_agent = $NavigationAgent2D
onready var animTree = $AnimationTree


func _physics_process(delta):
	pass
	#global_position = lerp(global_position, get_global_mouse_position(), 0.02)

func get_animState():
	return animTree.get("parameters/playback")
