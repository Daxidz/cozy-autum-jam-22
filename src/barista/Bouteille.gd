extends Node2D


var is_prepared: bool = false

var target = null

signal reached

export var empty_at_start: bool = true

func _ready():
	if empty_at_start:
		empty()
	else:
		$AnimationPlayer.play("prepared")
	
func empty():
	$AnimationPlayer.play("empty")
	is_prepared = false

func prepare(colors):
	material.set_shader_param("color_light", Color(colors[0]))
	material.set_shader_param("color_dark", Color(colors[1]))
	$AnimationPlayer.play("prepared")
	is_prepared = true


func _on_Area2D_body_entered(body):
	emit_signal("reached")


func _physics_process(delta):
	if target:
		global_position = lerp(global_position, target.global_position, 0.5)

