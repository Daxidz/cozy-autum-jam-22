extends Sprite

signal clicked

var selected: bool = false
var selectable: bool
var table = null

var col_light: Color
var col_dark: Color
var in_love: bool = false

var time_talk = 7

enum EYES { HAPPY, CLASSIC, SHOOKED, BLASE, VERY_HAPPY }

func set_eyes(id):
	$Eyes.frame = id

func happy_eyes():
	set_eyes(EYES.HAPPY)
func very_happy_eyes():
	set_eyes(EYES.VERY_HAPPY)
func shooked_eyes():
	set_eyes(EYES.SHOOKED)
func blase_eyes():
	set_eyes(EYES.BLASE)
func classic_eyes():
	set_eyes(EYES.CLASSIC)
	
func talk():
	$AnimationPlayer.play("talk")
	
func get_shooked():
	$AnimationPlayer.play("shock")
	
func emit_hearts():
	$AnimationPlayer.play("in_love")
	$InteractTimer.stop()
	
	
func get_blase():
	$AnimationPlayer.play("blase")
	$InteractTimer.stop()
	

func get_colors():
	return [col_light, col_dark]

func set_colors(light, dark):
	col_light = light
	col_dark = dark
	material.set_shader_param("color_light", Color(light))
	material.set_shader_param("color_dark", Color(dark))

func _ready():
	$InteractTimer.start(rand_range(7,9))
	selectable = false

func idle():
	$AnimationPlayer.play("idle")
	if $InteractTimer.is_stopped():
		$InteractTimer.start(rand_range(1,5))

func walk():
	$AnimationPlayer.play("walk")

func dance():
	$AnimationPlayer.play("dance")
	$InteractTimer.stop()
	

func _input(event):
	if selected and event.is_action_pressed("click"):
		emit_signal("clicked", self)
		
func outline(outlined):
	material.set_shader_param("corners", outlined)
	material.set_shader_param("outlined", outlined)


func make_selectable(new_selectable: bool):
	if not in_love:
		selectable = new_selectable

func _on_Area2D_mouse_entered():
	if selectable:
		selected = true
		outline(true)
		$AnimationPlayer.play("selected")

func _on_Area2D_mouse_exited():
	selected = false
	outline(false)
	var anim = $AnimationPlayer.current_animation
	if anim != "in_love" and anim != "shock" and anim != "dance":
		$AnimationPlayer.play("idle")


func _on_InteractTimer_timeout():
	var anim = $AnimationPlayer.current_animation
	if anim != "shock" and anim != "in_love":
		talk()
		print("talk")
		$InteractTimer.start(rand_range(1,5))
