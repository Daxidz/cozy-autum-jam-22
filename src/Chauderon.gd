extends Node2D


var is_selected: bool = false

signal melanger

func _ready():
	$Area2D.connect("mouse_entered", self, "_onArea2D_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_onArea2D_mouse_mouse_exited")

func _onArea2D_mouse_mouse_exited():
	modulate = Color.white
	is_selected = false

func _onArea2D_mouse_entered():
	modulate = Color.blue
	is_selected = true

func _input(event):
	if event.is_action_pressed("click") and is_selected:
		emit_signal("melanger")
