extends Navigation2D

# Code from https://github.com/godotengine/godot-demo-projects/tree/3.4-b0d4a7c/2d/navigation
export(float) var character_speed = 40.0
var path = []

var can_move: bool = false

onready var character = get_node("../Barista")

func _process(delta):
	var walk_distance = character_speed * delta
	move_along_path(walk_distance)


func _unhandled_input(event):
	if not event is InputEventMouseButton or not can_move:
		return
	_update_navigation_path(character.position, get_local_mouse_position())


func move_along_path(distance):
	var last_point = character.position
	while path.size():
		character.get_animState().travel("Walk")
		var distance_between_points = last_point.distance_to(path[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			character.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
		character.get_animState().travel("Idle")
	# The character reached the end of the path.
	character.position = last_point
	set_process(false)


func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class.
	# It returns a PoolVector2Array of points that lead you
	# from the start_position to the end_position.
	path = get_simple_path(start_position, end_position, true)
	# The first point is always the start_position.
	# We don't need it in this example as it corresponds to the character's position.
	path.remove(0)
	set_process(true)
