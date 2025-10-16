extends Node3D
class_name Main

@onready var player: Player = $Player
var window_has_focus = true

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			window_has_focus = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
		NOTIFICATION_APPLICATION_FOCUS_IN:
			window_has_focus = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta):
	if not window_has_focus:
		return
