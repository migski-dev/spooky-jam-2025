extends Control

func _ready():
	# Set up the control to fill the viewport
	anchor_left = 0
	anchor_top = 0
	anchor_right = 1
	anchor_bottom = 1
	
	# Center the UI elements
	_setup_ui_elements()

func _setup_ui_elements():
	# This assumes you have TitleLabel, PlayButton, SettingsButton as children

	var play_btn = $CenterContainer/VBoxContainer/PlayButton
	var settings_btn = $CenterContainer/VBoxContainer/SettingsButton

	
	# Center play button
	play_btn.anchor_left = 0.5
	play_btn.anchor_right = 0.5
	play_btn.anchor_top = 0.5
	play_btn.anchor_bottom = 0.5
	play_btn.grow_horizontal = Control.GROW_DIRECTION_BOTH
	play_btn.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	# Center settings button
	settings_btn.anchor_left = 0.5
	settings_btn.anchor_right = 0.5
	settings_btn.anchor_top = 0.65
	settings_btn.anchor_bottom = 0.65
	settings_btn.grow_horizontal = Control.GROW_DIRECTION_BOTH
	settings_btn.grow_vertical = Control.GROW_DIRECTION_BOTH
