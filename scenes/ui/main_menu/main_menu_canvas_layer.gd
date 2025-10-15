extends CanvasLayer

func _on_play_button_pressed():
	$AudioStreamPlayer.stop()
	$AspectRatioContainer/SubViewportContainer/SubViewport/Camera3D.current = false
	CameraManager.transition_camera($AspectRatioContainer/SubViewportContainer/SubViewport/Camera3D, get_tree().get_first_node_in_group("player").camera, 2.0, false)
	visible = false
	await CameraManager.transition_complete 
	SignalBus.on_game_start.emit()
	get_tree().get_first_node_in_group("main").window_has_focus = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().get_first_node_in_group("player").flashlight.visible = true
	


func _on_settings_button_pressed():
	$AspectRatioContainer/SubViewportContainer/Menu/CenterContainer/Settings.visible = true
	$AspectRatioContainer/SubViewportContainer/Menu/CenterContainer/VBoxContainer.visible = false


func _on_settings_back_pressed():
	$AspectRatioContainer/SubViewportContainer/Menu/CenterContainer/Settings.visible = false
	$AspectRatioContainer/SubViewportContainer/Menu/CenterContainer/VBoxContainer.visible = true
