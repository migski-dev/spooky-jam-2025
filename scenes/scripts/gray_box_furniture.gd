extends Node3D

@export var label_text : String = "furniture"

func _ready() -> void:
	for this_label : Label3D in [$Label3D, $Label3D2, $Label3D3, $Label3D4, $Label3D5, $Label3D6]:
		this_label.text = label_text
