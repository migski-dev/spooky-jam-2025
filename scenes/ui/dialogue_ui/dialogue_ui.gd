extends Control

@export var text_speed: float = 0.1 #0.03 
@onready var label: Label = $AspectRatioContainer/MarginContainer/Label
@onready var timer: Timer = $Timer

@export var full_text: String = ""
var visible_chars: int = 0
var is_typing: bool = false
var finished_typing: bool = false

signal typing_finished

func _ready():
	timer.timeout.connect(_on_timer_timeout)

# Call this to start typing text
func start_text(new_text: String, speed: float = text_speed):
	full_text = new_text
	text_speed = speed
	label.text = ""
	visible_chars = 0
	is_typing = true
	finished_typing = false
	timer.wait_time = text_speed
	timer.start()

func _on_timer_timeout():
	if visible_chars < full_text.length():
		visible_chars += 1
		label.text = full_text.substr(0, visible_chars)
	else:
		timer.stop()
		is_typing = false
		finished_typing = true
		emit_signal("typing_finished")
		await get_tree().create_timer(5.0).timeout
		visible = false

# Instantly display the full text (skip animation)
func skip_typing():
	if not is_typing:
		return
	timer.stop()
	label.text = full_text
	is_typing = false
	finished_typing = true
	emit_signal("typing_finished")
