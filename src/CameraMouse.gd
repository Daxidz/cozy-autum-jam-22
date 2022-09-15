extends Camera2D


onready var viewport_dim = get_viewport_rect().size
onready var is_up = true

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	if is_up:
		offset.y = lerp(offset.y, 0, 0.02)
		if mouse_pos.y > 2 * viewport_dim.y / 3:
			print("GOING DOWN")
			is_up = false
	else: 
		offset.y = lerp(offset.y, 256-144, 0.01)
#		offset.y = 256-144
		if mouse_pos.y < viewport_dim.y / 3:
			print("GOING UP")
			is_up = true
