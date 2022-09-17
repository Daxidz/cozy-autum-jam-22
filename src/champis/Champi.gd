extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_colors(light, dark):
	material.set_shader_param("color_light", Color(light))
	material.set_shader_param("color_dark", Color(dark))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func idle():
	$AnimationPlayer.play("idle")

func walk():
	$AnimationPlayer.play("walk")
