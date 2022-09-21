extends Node2D



signal reached 

func _ready():
	$Area2D.connect("mouse_entered", self, "_onArea2D_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_onArea2D_mouse_mouse_exited")

func _onArea2D_mouse_mouse_exited():
	$Chaudron.material.set_shader_param("outlined", false)
	$Chaudron.material.set_shader_param("cornered", false)

func _onArea2D_mouse_entered():
	$Chaudron.material.set_shader_param("outlined", true)
	$Chaudron.material.set_shader_param("cornered", true)


func _on_Area2D_body_entered(body):
	emit_signal("reached")
