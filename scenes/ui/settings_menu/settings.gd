extends Control



func _on_volume_value_changed(value):
	AudioManager.current_audio_level = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value/100))


func _on_check_box_pressed():
	AudioManager.current_audio_level = 0
	AudioServer.set_bus_volume_db(0, linear_to_db(0/100))
	

func _on_back_pressed():
	print('back')
	get_tree().get_first_node_in_group("main").exit_settings_menu()


func _on_visibility_changed():
	$MarginContainer/VBoxContainer2/VBoxContainer/Volume.value = AudioManager.current_audio_level
