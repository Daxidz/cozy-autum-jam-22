extends Node2D

signal start_game_clicked
var enabled: bool = false

var start_selected: bool = false



func set_enabled(new_enabled):
	enabled = new_enabled
	visible = new_enabled


func _input(event):
	if event.is_action_pressed("click") and start_selected:
		emit_signal("start_game_clicked")

func _on_Area2D_mouse_entered():
	start_selected = true
	if !$Sprite/Porte/AnimationPlayer.is_playing():
		$door.play()
	$Sprite/Porte/AnimationPlayer.play("open_door")
	
	


func _on_Area2D_mouse_exited():
	start_selected = false
	$Sprite/Porte/AnimationPlayer.play_backwards("open_door")


func _on_CloseBook_pressed():
	if !$Book.playing:
		$Book.play()
	$CanvasLayer.visible = !$CanvasLayer.visible


func _on_Credits_pressed():
	if !$Book.playing:
		$Book.play()
	$CanvasLayer.visible = !$CanvasLayer.visible
