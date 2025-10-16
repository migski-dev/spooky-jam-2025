extends Control
@export var top_label_text = "Turn On Flashlight"
@export var hint_text = "press F to toggle "
@onready var top_label = $MarginContainer/VBoxContainer/TopLabel
@onready var hint = $MarginContainer/VBoxContainer/Hint


func display_hint(top_text, bottom_text):
	hint.text = bottom_text
	top_label.text = top_text
	visible = true
	await get_tree().create_timer(2.5).timeout
	visible = false
