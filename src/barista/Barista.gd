extends KinematicBody2D

onready var nav_agent = $NavigationAgent2D
onready var animTree = $AnimationTree

func show_ingredient(ingredient):
	get_node("Ingredients/"+ ingredient).visible = true

func hide_ingredients():
	
	for s in $Ingredients.get_children():
		s.visible = false

func _ready():
	hide_ingredients()
	
func _physics_process(delta):
	pass
	#global_position = lerp(global_position, get_global_mouse_position(), 0.02)

func get_animState():
	return animTree.get("parameters/playback")
