extends Node2D


func _ready():
	$Menu.connect("start_game_clicked", self, "_on_Menu_start_game_clicked")
	$Menu.set_enabled(true)
	$ChampiInside.visible = false
	$ChampiInside.set_camera_enabled(false)

func _on_Menu_start_game_clicked():
	$Menu.set_enabled(false)
	$ChampiInside.visible = true
	$ChampiInside.start_game()
	$ChampiInside.set_camera_enabled(true)
