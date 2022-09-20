extends Node2D


var is_prepared: bool = false

func _ready():
	empty()
	
func empty():
	$AnimationPlayer.play("empty")

func prepare(colors):
	material.set_shader_param("color_light", Color(colors[0]))
	material.set_shader_param("color_dark", Color(colors[1]))
	$AnimationPlayer.play("prepared")
	
