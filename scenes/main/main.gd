extends Node3D
class_name Main

@onready var player: Player = $Player
@onready var paused = false
@onready var pause_menu = $PauseMenu
@onready var settings_menu = $Settings
@onready var in_main_menu = true
var window_has_focus = true


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			window_has_focus = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
		NOTIFICATION_APPLICATION_FOCUS_IN:
			if in_main_menu == false:
				window_has_focus = true
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		on_pause_menu()

func _physics_process(_delta):
	if not window_has_focus:
		return
		
func on_pause_menu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		pause_menu.show()
		Engine.time_scale = 0
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	paused = !paused
		

func enter_settings_menu():
	if !paused:
		return
	pause_menu.hide()
	settings_menu.show()
	
func exit_settings_menu():
	if !paused:
		return
	settings_menu.hide()
	pause_menu.show()
