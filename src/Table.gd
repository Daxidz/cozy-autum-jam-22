extends Node2D

signal champi_matched

var nb_champis: int = 0
const MAX_CHAMPI = 2

func get_champis():
	var champ1 = $YSort/Path1/PathFollow2D.get_child(0)
	var champ2 = $YSort/Path2/PathFollow2D.get_child(0)
	return [champ1, champ2]

func is_full() -> bool:
	return nb_champis == MAX_CHAMPI
	
func check_champis_color():
	var champs = get_champis()
	
	if champs[0].get_colors() == champs[1].get_colors():
		emit_signal("champi_matched", champs)

func add_champi(champi):
	nb_champis += 1
	if nb_champis <= MAX_CHAMPI:
		var path = get_node("YSort/Path" + str(nb_champis) +"/PathFollow2D")
		path.offset = 0.0
		champi.table = self
		path.add_child(champi)
		var tween = get_tree().create_tween()
		tween.tween_callback(champi, "walk")
		tween.tween_property(path, "unit_offset", 1.0, 5)
		tween.tween_callback(champi, "idle")
	else:
		nb_champis == MAX_CHAMPI
