extends Node2D



var nb_champis: int = 0
const MAX_CHAMPI = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func is_full() -> bool:
	return nb_champis == MAX_CHAMPI
	
#func check_champis_color():
#	if $YSort/Path1/PathFollow2D. 

func add_champi(champi):
	nb_champis += 1
	if nb_champis <= MAX_CHAMPI:
		var path = get_node("YSort/Path" + str(nb_champis) +"/PathFollow2D")
		path.offset = 0.0
		path.add_child(champi)
		var tween = get_tree().create_tween()
		tween.tween_callback(champi, "walk")
		tween.tween_property(path, "unit_offset", 1.0, 5)
		tween.tween_callback(champi, "idle")
	else:
		nb_champis == MAX_CHAMPI
