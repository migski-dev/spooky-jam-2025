extends Control


func _on_quit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	get_tree().get_first_node_in_group("main").on_pause_menu()


func _on_settings_pressed():
	get_tree().get_first_node_in_group("main").enter_settings_menu()
