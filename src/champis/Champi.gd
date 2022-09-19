extends Sprite

signal clicked

var selected: bool = false
var selectable: bool

var col_light: Color
var col_dark: Color

func set_colors(light, dark):
	material.set_shader_param("color_light", Color(light))
	material.set_shader_param("color_dark", Color(dark))

func _ready():
	selectable = false

func idle():
	$AnimationPlayer.play("idle")

func walk():
	$AnimationPlayer.play("walk")

func _input(event):
	if selected and event.is_action_pressed("click"):
		emit_signal("clicked", self)
		pass
		

func make_selectable(new_selectable: bool):
	selectable = new_selectable

func _on_Area2D_mouse_entered():
	if selectable:
		selected = true
		modulate = Color.yellow

func _on_Area2D_mouse_exited():
	selected = false
	modulate = Color.white
