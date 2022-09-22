extends Camera2D


onready var viewport_dim = get_viewport_rect().size
onready var is_up = true

var should_move: bool = false
func _physics_process(delta):
	if not should_move:
		offset.y = 0
		return
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	if is_up:
		offset.y = lerp(offset.y, 0, 0.06)
		if mouse_pos.y > 2*viewport_dim.y / 3:
			is_up = false
	else: 
		offset.y = lerp(offset.y , min(mouse_pos.y, 112),  0.02)
		if mouse_pos.y < viewport_dim.y / 8:
			is_up = true
