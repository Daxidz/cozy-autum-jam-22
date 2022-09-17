extends Camera2D


onready var viewport_dim = get_viewport_rect().size
onready var is_up = true

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	
	if is_up:
		offset.y = lerp(offset.y, 0, 0.02)
		if mouse_pos.y > viewport_dim.y / 2:
			is_up = false
	else: 
		offset.y = lerp(offset.y, mouse_pos.y, 0.02)
		if mouse_pos.y < viewport_dim.y / 4:
			is_up = true
