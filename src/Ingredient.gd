extends Node2D


var is_selected: bool = false

signal clicked
signal reached

onready var sprite_small = load("res://assets/img/" + name + ".png")

func _ready():
	$Area2D.connect("mouse_entered", self, "_onArea2D_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_onArea2D_mouse_mouse_exited")
	$Sprite.material.set_shader_param("outlined", true)



func _onArea2D_mouse_mouse_exited():
#	$Sprite.material.set_shader_param("outlined", false)
	$Sprite.material.set_shader_param("cornered", false)
	is_selected = false

func _onArea2D_mouse_entered():
	print("ENTERED")
	$Sprite.material.set_shader_param("cornered", true)
	is_selected = true

func _input(event):
	if event.is_action_pressed("click") and is_selected:
		emit_signal("clicked", name.to_lower())


func _on_Area2D_body_entered(body):
	emit_signal("reached", name)
